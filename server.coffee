http = require 'http'
fs = require 'fs'
path = require 'path'
express = require 'express'

io = require('socket.io').listen 8080
io.sockets.on 'connection', (socket) ->
    console.log 'connection'
    socket.emit 'news', { 'hello': 'world' }
    socket.on 'my other event', (data) ->
        console.log data

app = express.createServer()
app.set 'views', __dirname
app.set 'view engine', 'jade'
app.get '/', (req, res) ->
    res.render 'index', { layout: false }
app.listen 3000, ->
    console.log "listening on port 3000"

map = [0, 0, 0,
       0, 0, 0,
       0, 0, 0]
