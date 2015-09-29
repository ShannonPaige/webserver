class Parse
  def self.call(client)
    method, path, version = client.gets.split(" ")
    env_hash = {}
    env_hash["REQUEST_METHOD"] = method
    env_hash["PATH_INFO"] = path
    env_hash["VERSION"] = version
    headers = parse_headers(client)
    env_hash = parse_body(client)
  end

  def self.parse_headers(client)
    headers = {}
    client.each_line do |line|
      break if line == "\r\n"
      key, value = line.split(': ')
      headers[key] = value
    end
    headers
  end

  def self.parse_body(client)
    if headers.keys.include?("Content-Length")
      content_length = headers.fetch("Content-Length").chomp.to_i
      env_hash["rack.input"] = StringIO.new(client.read(content_length))
    else
      env_hash["rack.input"] = ""
    end
    env_hash
  end
end
