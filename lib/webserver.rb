require 'pry'

# Tell my computer that web requests to http://localhost:9292 should be sent to me
require 'socket'
port       = 9292
tcp_server = TCPServer.new(port)

# Wait for a request
client = tcp_server.accept

# Read the request
first_line = client.gets.split(" ")
method = first_line[0]
path = first_line[1]
version = first_line[2]
hash = {}
client.each_line do |line|
  break if line == "\r\n"
  key, value = line.split(': ')
  hash[key] = value
end
binding.pry

# Write the response

client.print("HTTP/1.1 200 OK\r\n")
client.print("Content-Type: text/html; charset=UTF-8\r\n")
client.print("Content-Length: 50\r\n")
client.print("\r\n")
client.print("<HTML><HEAD><h1>Hello World!</h1></HEAD><BODY></BODY>\r\n")
client.close

# I'm done now, computer ^_^
tcp_server.close_read
tcp_server.close_write
