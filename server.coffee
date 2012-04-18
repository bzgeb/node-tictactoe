http = require 'http'
fs = require 'fs'
path = require 'path'
express = require 'express'

board = [0, 0, 0,
         0, 0, 0,
         0, 0, 0]

players = 0

io = require('socket.io').listen 8080
io.sockets.on 'connection', (socket) ->
    ++players
    console.log 'connection'

    id = players
    socket.emit 'board', {id: id, board: board}

    socket.on 'move', (params) ->
        io.sockets.emit 'move', params
        console.log params

io.sockets.on 'disconnect', (socket) ->
    --players
    console.log 'disconnect'

io.sockets.on 'reload', ->
    --players
    console.log 'reload'

app = express.createServer()
app.configure ->
    app.set 'views', __dirname
    app.set 'view engine', 'jade'
    app.use express.static(__dirname + '/public/javascripts')
    app.use express.bodyParser()
    app.use express.methodOverride()
    app.use app.router

app.get '/', (req, res) ->
    res.render 'index', { layout: false }

app.listen 3000, ->
    console.log "listening on port 3000"

