player_id = 0
board_data = []

socket = io.connect 'http://localhost:8080'
socket.on 'board', (params) ->
    console.log params
    player_id = params['id']
    board_data = params['board']
    toggle_turn params['turn']
    console.log "Data: #{board_data}"
    for i in [0..2]
        for j in [0..2]
            draw_x i, j if board_data[i][j] == 1
            draw_o i, j if board_data[i][j] == 2

socket.on 'draw', (params) ->
    id = params['id']
    x_pos = params['x']
    y_pos = params['y']

    draw_x x_pos, y_pos if id == 1
    draw_o x_pos, y_pos if id == 2

socket.on 'move', (params) ->
    console.log params

socket.on 'turn', (params) ->
    toggle_turn params['id']

board = 0

board_down = (event) ->
    x_pos = event.pageX - board.offsetLeft
    y_pos = event.pageY - board.offsetTop

    x_index = Math.floor(x_pos / 100)
    y_index = Math.floor(y_pos / 100)

    socket.emit 'move', {id:player_id, x:x_index, y:y_index}

window.addEventListener 'load', ->
    board = document.getElementById 'board'
    board.addEventListener 'mousedown', board_down, false

get_tile = (x, y) ->
    x = Math.floor(x / 100)
    y = Math.floor(y / 100)

    x = 2 if x > 2
    y = 2 if y > 2

draw_x = (x_index, y_index) ->
    x1 = x_index * 100 + 10
    x2 = x_index * 100 + 90
    x3 = x_index * 100 + 90
    x4 = x_index * 100 + 10

    y1 = y_index * 100 + 10
    y2 = y_index * 100 + 90
    y3 = y_index * 100 + 10
    y4 = y_index * 100 + 90

    cxt = board.getContext '2d'
    cxt.beginPath()
    cxt.moveTo x1, y1
    cxt.lineTo x2, y2
    cxt.moveTo x3, y3
    cxt.lineTo x4, y4
    cxt.stroke()
    cxt.closePath()

draw_o = (x_index, y_index) ->
    x_pos = x_index * 100 + 50
    y_pos = y_index * 100 + 50

    cxt = board.getContext '2d'
    cxt.beginPath()
    cxt.arc(x_pos, y_pos, 45, 0, Math.PI * 2, true)
    cxt.stroke()
    cxt.closePath()

toggle_turn = (next_turn) ->
    turn_div = document.getElementById 'turn'
    if player_id > 2
        turn_div.innerHTML = "You are a spectator"
        return

    if next_turn == player_id
        turn_div.innerHTML = "It's your turn"
    else
        turn_div.innerHTML = "It's the other player's turn"
