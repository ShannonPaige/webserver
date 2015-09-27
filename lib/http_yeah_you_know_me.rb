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
    headers = {}
    client.each_line do |line|
      break if line == "\r\n"
      key, value = line.split(': ')
      headers[key] = value
    end
    response(env_hash, client)
  end

  def response(env_hash, client)
    response_array = app.call(env_hash)
    client.print("HTTP/1.1 #{response_array[0]} OK\r\n")
    response_array[1].each { |key, value| client.print "#{key}: #{value}\r\n" }
    client.print("\r\n")
    client.print response_array[2][0]
    client.close
  end

  def stop
    server.close_read
    server.close_write
  end
end
