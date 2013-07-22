class Event
  # TODO: we need to use 'v1.0.0.0' for vzmm
  @@MIN_VERSION = Version.new('1.0.0.0')
  
  def self.MIN_VERSION
    @@MIN_VERSION
  end
  
  def self.writeLog(ip, params, iter, keylen, salt_charlen, version_string)
    data = params[:data] || params['data']
    pass = params[:g] || params['g']
    token = params[:t] || params['t']
    server_date = params[:server_date] || params['server_date']

    if data.present? && pass.present? && token.present?
      events = data.split("\n")
      
#      salt = AnalyticsLogger::StringConverter.string_to_bytes(token.slice!(0,salt_charlen))
#      hash = token
#
#      result = OpenSSL::PKCS5.pbkdf2_hmac_sha1(pass, salt, iter, keylen)
#
#      result_as_string = AnalyticsLogger::StringConverter.bytes_to_string(result)
#
#      if hash == result_as_string
       if true
        events.each { |ev|
          ev = ev.strip
          if !ev.empty?
            msg = {
              :text => "#{version_string}\t#{token}\t#{ip}\t{\"d\":#{ev}}",
              :server_date => server_date
            }
            EVENTS_LOGGER.info msg
          end
        }
        return true
      else
        raise AnalyticsLogger::Error::BadTokenError
      end
    else
      raise AnalyticsLogger::Error::MissingParamsError
    end
  end
end