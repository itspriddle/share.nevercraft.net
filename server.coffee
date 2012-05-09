http = require 'http'

server = http.createServer (request, response) ->
  hostname      = "host88.hrwebservices.net"
  proxy_url     = "/~priddle#{request.url}"
  proxy_client  = http.createClient 80, hostname
  proxy_request = proxy_client.request request.method, proxy_url, request.headers

  proxy_request.addListener 'response', (proxy_response) ->
    proxy_response.addListener 'data', (chunk) ->
      response.write chunk, 'binary'

    proxy_response.addListener 'end', ->
      response.end()

    response.writeHead proxy_response.statusCode, proxy_response.headers

  request.addListener 'data', (chunk) ->
    proxy_request.write chunk, 'binary'

  request.addListener 'end', ->
    proxy_request.end()

server.listen process.env.PORT || 3000
