require 'socket'
require 'stringio'
require 'pry'
require_relative 'parse'

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
      env_hash = Parse.call(client)
      response(env_hash, client)
    end
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
