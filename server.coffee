http = require 'http'
server = http.createServer()
server.on 'request', (req, res) ->
    res.writeHead 200, {
        'Content-Type': 'text/plain',
        'Cache-Control': 'max-age=3600'
    }
    res.end req.url

server.listen 4000
server.once 'connection', (stream) ->
    console.log 'First Connection'

