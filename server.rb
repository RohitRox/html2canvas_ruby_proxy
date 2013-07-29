require 'rubygems'
require 'eventmachine'
require 'evma_httpserver'
require "em-http-request"
require 'base64'
require 'json'
require 'cgi'

class ImageProxy  < EM::Connection

  include EM::HttpServer

  def post_init
    super
    no_environment_strings
  end

  def process_http_request

    #   @http_protocol
    #   @http_request_method
    #   @http_cookie
    #   @http_if_none_match
    #   @http_content_type
    #   @http_path_info
    #   @http_request_uri
    #   @http_query_string
    #   @http_post_content
    #   @http_headers

    resp = EM::DelegatedHttpResponse.new( self )

    resp.headers={'Access-Control-Max-Age' => 5*60*1000, 
                    'Access-Control-Allow-Origin' => '*',
                    'Access-Control-Request-Method' => '*',
                    'Access-Control-Allow-Methods' =>'OPTIONS, GET',
                    'Access-Control-Allow-Headers' =>'*'}
    resp.status = 200

    if (@http_request_method == 'options')

      resp.send_response
      
    else

      puts "Request: #{@http_query_string}"

      callback = CGI::parse(@http_query_string)['callback'][0]

      img_url = CGI::parse(@http_query_string)['url'][0]

      ext = img_url.split('.')[-1]

      http = EventMachine::HttpRequest.new(img_url).get

      http.callback do |response|
        content = 'data:image/'+ext+';base64,'+Base64.encode64(http.response.chomp)
        resp.content_type 'application/json'
        resp.content = "#{callback}(#{content.to_json})"
        resp.send_response
      end

    end

  end

end

EM::run {
  EM::start_server("0.0.0.0", 8082, ImageProxy)
  puts "Listening on port 8082 ... "
}