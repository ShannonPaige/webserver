require 'socket'
require 'pry'

class HttpYeahYouKnowMe
  attr_accessor :port, :app, :server
  def initialize(port, app)
    @port = port
    @app = app
    @server = TCPServer.new(port)
  end

  def start
    until server.closed? do
      client = server.accept
      parse_request(client)
    end
  end

  def parse_request(client)
    first_line = client.gets.split(" ")
    method = first_line[0]
    path = first_line[1]
    version = first_line[2]
    env_hash = {}
    env_hash["REQUEST_METHOD"] = method
    env_hash["PATH_INFO"] = path
    env_hash["VERSION"] = version
    # hash = {}
    # client.each_line do |line|
    #   break if line == "\r\n"
    #   key, value = line.split(': ')
    #   hash[key] = value
    # end
    response(env_hash, client)
  end

  def response(env_hash, client)
    stuff = app.call(env_hash)
    client.print("HTTP/1.1 #{stuff[0]} OK\r\n")
    stuff[1].each do |key, value|
      client.print "#{key}: #{value}\r\n"
    end
    client.print("\r\n")
    client.print stuff[2][0]
    client.close
  end

  def stop
    server.close_read
    server.close_write
  end
end


# client.print("HTTP/1.1 200 OK\r\n")
# client.print("Content-Type: text/html; charset=UTF-8\r\n")
# client.print("Content-Length: 50\r\n")
# client.print("\r\n")
# client.print("<HTML><HEAD><h1>Hello World!</h1></HEAD><BODY></BODY>\r\n")
# client.close
