require 'openssl'

class OldEventsController < ApplicationController
  protect_from_forgery :except => [:create]

  # Require ssl
  # ssl_required :create

  # Allow ssl or non-ssl
  ssl_allowed :create
  
  def create
    # TODO: set MAX_SIZE of data
    success = false
    version = params[:v]
    ip = request.remote_ip

    begin
      if !version.present?
        raise AnalyticsLogger::Error::MissingParamsError
      else
        # v.1.0.0
        version_array = version.delete('v').split('.')
        version_int = Integer(version_array[0])*1000000 + Integer(version_array[1])*1000 + Integer(version_array[2])
        case version_int
          when 0..999999
            raise AnalyticsLogger::Error::BadVersionError
          else # 1000000..1000001
            iter = 1000
            keylen = 48
            salt_charlen = 16
            success = Event.writeLog(request.remote_ip, params, iter, keylen, salt_charlen, version_int)
        end
      end
    rescue AnalyticsLogger::Error::BadVersionError
      # success = false is already set
      logger.warn "#{ip} BAD_VERSION PostData: #{request.raw_post}"
    rescue AnalyticsLogger::Error::MissingParamsError
      success = true
      logger.warn "#{ip} MISSING_PARAMS PostData: #{request.raw_post}"
    rescue AnalyticsLogger::Error::BadTokenError
      success = true
      logger.warn "#{ip} BAD_TOKEN PostData: #{request.raw_post}"
    rescue StandardError => e
      # success = false is already set
      logger.warn "#{ip} UNKNOWN_ERROR PostData: #{request.raw_post}"
      logger.warn "#{ip} UNKNOWN_ERROR Exception: #{e.to_s}"
      logger.warn "#{ip} UNKNOWN_ERROR Exception: #{e.backtrace.join("\n")}"
    end

    if success
      render :json => { :success => true }, :status => 200
    else
      # only send false if we want the client to retry sending data
      render :json => { :success => false }, :status => 400
    end
  end
end
