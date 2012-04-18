socket = io.connect 'http://localhost:8080'
socket.on 'board', (board) ->
    console.log board
    socket.emit 'move', {id: 1, pos: 0}
