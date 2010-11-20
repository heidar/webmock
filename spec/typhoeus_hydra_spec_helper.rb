require 'ostruct'

module TyphoeusHydraSpecHelper
  class FakeTyphoeusHydraError < StandardError; end
  
  
  def http_request(method, uri, options = {}, &block)
    uri.gsub!(" ", "%20") #typhoeus doesn't like spaces in the uri
    response = Typhoeus::Request.run(uri,
      {
        :method  => method,
        :body    => options[:body],
        :headers => options[:headers],
        :timeout => 2000 # milliseconds
      }
    )
    raise FakeTyphoeusHydraError.new if response.code.to_s == "0"
    OpenStruct.new({
      :body => response.body,
      :headers => WebMock::Util::Headers.normalize_headers(join_array_values(response.headers_hash)),
      :status => response.code.to_s,
      :message => response.status_message
    })
  end

  def client_timeout_exception_class
    FakeTyphoeusHydraError
  end

  def connection_refused_exception_class
    FakeTyphoeusHydraError
  end

  def setup_expectations_for_real_request(options = {})
    #TODO
  end

  def http_library
    :typhoeus
  end

end
