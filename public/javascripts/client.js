// Generated by CoffeeScript 1.3.1
(function() {
  var socket;

  socket = io.connect('http://localhost:8080');

  socket.on('board', function(board) {
    console.log(board);
    return socket.emit('move', {
      id: 1,
      pos: 0
    });
  });

}).call(this);
