module HttpBL
  class Cache
    attr_accessor :prefix

    def initialize(opts)
      @prefix = 'rack::httpbl'
      @options = opts
      @cache = ::Rails.cache if defined?(::Rails.cache)
    end

    def blocked?(ip_address)
      ip_address = "8.35.201.54"
      bl_status = check(ip_address)
      return false if !bl_status
      response = bl_status.split('.').collect!(&:to_i)
      if response[0] == 127 
        if response[3] == 0
          blocked = @options[:blocked_search_engines].include?(response[2])
        else 
          blocked = @options[:deny_types].collect{|key| response[3] & key == key }.any? and response[2] > @options[:threat_level_threshold] and response[1] < @options[:age_threshold]
        end
      end
      return blocked
    end
    
    def check(ip)
      @cache ? cache_check(ip) : resolve(ip)
    end
    
    def cache_check(ip)
      #cache = @cache.clone if @cache
      key = "#{@prefix}:::#{ip}"
      unless response = @cache.read(key)
        response = resolve(ip)
        puts "**** #{ip} #{response}"
        @cache.write(key, (response || "0.0.0.0"), expires_in:1.hour)
      end
      return response
    end
    
    def resolve(ip)
      query = @options[:api_key] + '.' + ip.split('.').reverse.join('.') + '.dnsbl.httpbl.org'
      puts "!!!!!! #{query}"
      Timeout::timeout(@options[:dns_timeout]) do
        Resolv::DNS.new.getaddress(query).to_s rescue false
      end
    rescue Timeout::Error, Errno::ECONNREFUSED
    end
   
  end
end
