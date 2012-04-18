socket = io.connect 'http://localhost:8080'
socket.on 'board', (params) ->
    console.log params
    socket.emit 'move', {id: params['id'], pos: 0}

document.addEventListener 'keydown', (event) ->
    console.log event
    socket.emit 'move', {id:0, pos: 0}

board = 0

board_down = (event) ->
    console.log event
    console.log "X: #{event.pageX - board.offsetLeft}"
    console.log "Y: #{event.pageY - board.offsetTop}"
    x_pos = event.pageX - board.offsetLeft
    y_pos = event.pageY - board.offsetTop
    get_tile x_pos, y_pos

window.addEventListener 'load', ->
    board = document.getElementById 'board'
    board.addEventListener 'mousedown', board_down, false

get_tile = (x, y) ->
    x = Math.floor(x / 100)
    y = Math.floor(y / 100)

    x = 2 if x > 2
    y = 2 if y > 2

    console.log "x tile: #{x}"
    console.log "y tile: #{y}"
