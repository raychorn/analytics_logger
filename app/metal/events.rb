# Allow the metal piece to run in isolation
require(File.dirname(__FILE__) + "/../../config/environment") unless defined?(Rails)

class Events
  def self.call(env)
    if env['REQUEST_METHOD'] == 'POST' && env['PATH_INFO'] =~ /^\/events/
      req = Rack::Request.new(env)
      @params = req.params
      
      # TODO: set MAX_SIZE of data
      success = false
      
      # Note that we need to use the string instead of the symbol here when retrieving parameters
      version_string = @params['v']
      ip = req.ip
  
      begin
        if !version_string.present?
          raise AnalyticsLogger::Error::MissingParamsError
        else
          # TODO: remove delete 'v' method call after separating out vzmm
          version_parsed = Version.new(version_string.delete('v'))
          if version_parsed < Event.MIN_VERSION
            raise AnalyticsLogger::Error::BadVersionError
          else
            iter = 1000
            keylen = 48
            salt_charlen = 16
            success = Event.writeLog(ip, @params, iter, keylen, salt_charlen, version_string)
          end
        end
      rescue AnalyticsLogger::Error::BadVersionError
        # success = false is already set
        Rails.logger.warn "#{ip} BAD_VERSION PostData: #{req.body.read}"
      rescue AnalyticsLogger::Error::MissingParamsError
        success = true
        Rails.logger.warn "#{ip} MISSING_PARAMS PostData: #{req.body.read}"
      rescue AnalyticsLogger::Error::BadTokenError
        success = true
        Rails.logger.warn "#{ip} BAD_TOKEN PostData: #{req.body.read}"
      rescue StandardError => e
        # success = false is already set
        Rails.logger.warn "#{ip} UNKNOWN_ERROR PostData: #{req.body.read}"
        Rails.logger.warn "#{ip} UNKNOWN_ERROR Exception: #{e.to_s}"
        Rails.logger.warn "#{ip} UNKNOWN_ERROR Exception: #{e.backtrace.join("\n")}"
      end
      
      if success
        return [200, {"Content-Type" => "application/json"}, [{ :success => true }.to_json]]
      else
        return [400, {"Content-Type" => "application/json"}, [{ :success => false }.to_json]]
      end
    else
      # We must return a 404 here in order for the Rails controller to pick up where the Metal left off.
      # Apparently any response code other than 404 and the Rails controller will not handle the request. 
      [404, {"Content-Type" => "text/html"}, ["Not Found"]]
    end
  end
end
