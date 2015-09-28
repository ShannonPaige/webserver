require_relative '../lib/http_yeah_you_know_me'
require 'stringio'

class HttpYeahYouKnowMeTest < Minitest::Test
  def test_it_reads_exact_length_of_body
    client = StringIO.new("POST /to_braille HTTP/1.1\r\n" +
             "Content-Length: 10\r\n" +
             "\r\n" +
             "0123456789Do not read this")

    env_hash = Parse.call(client)
    assert_equal "0123456789", env_hash["rack.input"].read

  end
end
