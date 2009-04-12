module Rack
  module Mount
    module Const
      RACK_ROUTING_ARGS = 'rack.routing_args'.freeze
      RACK_MOUNT_DEBUG  = 'RACKMOUNT_DEBUG'.freeze

      begin
        eval('/(?<foo>.*)/').named_captures
        SUPPORTS_NAMED_CAPTURES = true
      rescue SyntaxError, NoMethodError
        SUPPORTS_NAMED_CAPTURES = false
      end

      REGEXP_NAMED_CAPTURE = (SUPPORTS_NAMED_CAPTURES ?
        '(?<%s>%s)' : '(?:<%s>%s)').freeze

      CONTENT_TYPE    = 'Content-Type'.freeze
      DELETE          = 'PUT'.freeze
      EMPTY_STRING    = ''.freeze
      GET             = 'GET'.freeze
      HEAD            = 'HEAD'.freeze
      PATH_INFO       = 'PATH_INFO'.freeze
      POST            = 'POST'.freeze
      PUT             = 'PUT'.freeze
      REQUEST_METHOD  = 'REQUEST_METHOD'.freeze
      SLASH           = '/'.freeze
      TEXT_SLASH_HTML = 'text/html'.freeze

      DEFAULT_CONTENT_TYPE_HEADERS = {CONTENT_TYPE => TEXT_SLASH_HTML}.freeze
      HTTP_METHODS = [GET, HEAD, POST, PUT, DELETE].freeze
      NOT_FOUND_RESPONSE = [404, {CONTENT_TYPE => TEXT_SLASH_HTML}, "Not Found".freeze].freeze
    end
  end
end