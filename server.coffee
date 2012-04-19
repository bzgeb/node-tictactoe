http = require 'http'
fs = require 'fs'
path = require 'path'
express = require 'express'

class Game
    init: ->
        @board = [[0, 0, 0],
                  [0, 0, 0],
                  [0, 0, 0]]

        @num_players = 0
        @turn = 0
        @has_winner = false
        @winner = 0

    add_player: ->
        ++@num_players

    remove_player: ->
        --@num_players

    current_turn: ->
        @turn + 1

    change_turn: ->
        @turn = 1 - @turn
        io.sockets.emit 'turn', {id:this.current_turn()}

    check_win_condition: ->
        return true if @board[0][0] == @board[0][1] == @board[0][2] and @board[0][0] + @board[0][1] + @board[0][2] != 0
        return true if @board[1][0] == @board[1][1] == @board[1][2] and @board[1][0] + @board[1][1] + @board[1][2] != 0
        return true if @board[2][0] == @board[2][1] == @board[2][2] and @board[2][0] + @board[2][1] + @board[2][2] != 0
    
        return true if @board[0][0] == @board[1][0] == @board[2][0] and @board[0][0] + @board[1][0] + @board[2][0] != 0
        return true if @board[0][1] == @board[1][1] == @board[2][1] and @board[0][1] + @board[1][1] + @board[2][1] != 0
        return true if @board[0][2] == @board[1][2] == @board[2][2] and @board[0][2] + @board[1][2] + @board[2][2] != 0
    
        return true if @board[0][0] == @board[1][1] == @board[2][2] and @board[0][0] + @board[1][1] + @board[2][2] != 0
        return true if @board[2][0] == @board[1][1] == @board[0][2] and @board[2][0] + @board[1][1] + @board[0][2] != 0
    
        return false

    valid_move: (x_index, y_index, player_id) ->
        return @board[x_index][y_index] == 0 and player_id == this.current_turn()

    try_move: (x_index, y_index, player_id) ->
        if this.valid_move x_index, y_index, player_id
            @board[x_index][y_index] = player_id
            this.broadcast_draw player_id, x_index, y_index
            this.change_turn()
            @has_winner = this.check_win_condition()
            if @has_winner
                this.end_game()

    broadcast_draw: (player_id, x_index, y_index) ->
        io.sockets.emit 'draw', {id:player_id, x:x_index, y:y_index}

    end_game: ->
        io.sockets.emit 'game_over', {}

app = new Game()
app.init()

io = require('socket.io').listen 8080
io.sockets.on 'connection', (socket) ->
    id = app.add_player()
    console.log 'user connected'
    socket.emit 'board', {id: id, board: app.board, turn:app.current_turn()}

    socket.on 'move', (params) ->
        if app.has_winner
            return

        x_index = params['x']
        y_index = params['y']
        id = params['id']

        #try move
        app.try_move x_index, y_index, id

    socket.on 'disconnect', (socket) ->
        app.remove_player()
        console.log 'user disconnected'

    socket.on 'reload', (socket) ->
        app.remove_player()
        console.log 'reload'

express_app = express.createServer()
express_app.configure ->
    express_app.set 'views', __dirname
    express_app.set 'view engine', 'jade'
    express_app.use express.static(__dirname + '/public/javascripts')
    express_app.use express.bodyParser()
    express_app.use express.methodOverride()
    express_app.use express_app.router

express_app.get '/', (req, res) ->
    res.render 'index', { layout: false }

express_app.listen 3000, ->
    console.log "listening on port 3000"

