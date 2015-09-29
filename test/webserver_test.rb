require_relative '../lib/http_yeah_you_know_me'
require 'stringio'

class HttpYeahYouKnowMeTest < Minitest::Test
  def setup
    @client = StringIO.new("POST /to_braille HTTP/1.1\r\n" +
             "Content-Length: 10\r\n" +
             "\r\n" +
             "0123456789Do not read this")
    @env_hash = Parse.call(@client)
  end

  def test_it_reads_exact_length_of_body
    assert_equal "0123456789", @env_hash["rack.input"].read
  end

  def test_it_stores_the_first_word_in_the_REQUEST_METHOD_key
    assert_equal "POST", @env_hash["REQUEST_METHOD"]
  end

  def test_it_stores_the_second_word_in_the_PATH_INFO_key
    assert_equal "/to_braille", @env_hash["PATH_INFO"]
  end

  def test_it_stores_the_third_word_in_the_VERSION_key
    assert_equal "HTTP/1.1", @env_hash["VERSION"]
  end
end
