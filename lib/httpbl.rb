# The Httpbl middleware 
require 'timeout'

module HttpBL
  autoload :Resolv, 'resolv'
  autoload :Cache, 'httpbl/cache'  

  class << self
    def new(app, options = {})
      @app = app
      @options = {
        :blocked_search_engines => [],
        :age_threshold => 10,
        :threat_level_threshold => 2,
        :deny_types => [1, 2, 4, 8, 16, 32, 64, 128], # 8..128 aren't used as of 10/2009, but might be used in the future
        :dns_timeout => 0.5,
        :whitelist => Proc.new {}
      }.merge(options)
      raise "Missing :api_key for Http:BL middleware" unless @options[:api_key]

      @cache = Cache.new(@options)
      
      self
    end

    def call(env)
      request = Rack::Request.new(env)
      
      if whitelisted?(request)
        @app.call(env)
      elsif blocked?(request)
        blocked_response(request)
      else
        @app.call(env)
      end
    end

    def whitelisted?(request)
      @options[:whitelist].call(request)
    end
    
    def blocked_response(request)
      [403, {"Content-Type" => "text/html"}, "<h1>403 Forbidden</h1> Request IP is listed as suspicious by <a href='http://projecthoneypot.org/ip_#{request.ip}'>Project Honeypot</a>"]
    end

    def blocked?(request)
      @cache.blocked?(request.ip)
    end
  end
end
