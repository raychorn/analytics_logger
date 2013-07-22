module AnalyticsLogger

  require 'fileutils'
  require 'socket'
  require 'rubygems'
  require 'logrotate'

  class EventsLogger < Logger
    # different than the default format_message in that msg must be a hash
    def format_message(severity, timestamp, progname, msg)
      if msg[:server_date].blank?
        "#{timestamp.utc.strftime("%Y-%m-%d %H:%M:%S")}\t#{msg[:text]}\n"
      else
        "#{msg[:server_date]}\t#{msg[:text]}\n"
      end
    end
  end

  class LogHelper
    def self.read(filepath)
      f = File.new(filepath)
      log = f.readlines
      f.close
      return log
    end
    
    def self.rotate(filepath)
      app = APP_CONFIG['app_name']
      success = false
      filename = ''
      hostname = Socket.gethostname
      hostname = hostname.sub(/[.]/, '_')
      output_directory = RAILS_ROOT + '/log/processed'
      if (!File.directory?(output_directory)) then Dir.mkdir(output_directory) end

      lastaction = Proc.new() do
         #Restart Passenger to access HUP Process ID correctly
         `touch #{RAILS_ROOT}/tmp/restart.txt`
      end

      options = {
        :gzip => false,
        :date_time_ext => true,
        :date_time_format => "%Y%m%d_%H%M_#{hostname}_#{app}",
        :directory => output_directory,
        :post_rotate => lastaction,
      }
      
      #`which hadoop`
      #hadoop = $?.success?
      hadoop = File.exists?('/usr/bin/hadoop')
      if (!hadoop)
        Rails.logger.warn "Rotate Initiated but Hadoop Command Not Found! PATH=" + ENV['PATH']
      end
      if (!File.zero?(filepath) && hadoop)
        result = LogRotate.rotate_file(filepath, options)
        filename = result.new_rotated_file
        #puts 'rotated file: ' + filename
        `/usr/bin/hadoop dfs -put #{filename} /user/hadoop/#{app}/#{filename}`
        success = true
      end
      return success
    end
  end

  class EventsHelper
    
    def self.read_compressed_events()
      log = ""
      @days = 5
      current_time = Time.new
      start_time = current_time - 86400*(@days-1)
      @days.times do |x| 
        time = start_time + 86400*x
        log_time = time.utc.strftime("%Y%m%d")
        newpath = RAILS_ROOT + '/log/processed/events.log-' + log_time + '.gz'
        begin
        Zlib::GzipReader.open(newpath) {|gz|
          newlog = gz.readlines
          gz.close
          log << "Start of events.log-" + log_time + ":\n"
          log << newlog.to_s
        }
        rescue
          nil
        end
      end
      return log.to_a
    end
    
    def self.read_compressed_events_date(from_date)
      log = ""
      current_time = Time.new
      from_time = Time.parse(from_date)
      @days = ((current_time - from_time)/86400).to_i + 1
      start_time = current_time - 86400*(@days-1)
      @days.times do |x| 
        time = start_time + 86400*x
        log_time = time.utc.strftime("%Y%m%d")
        newpath = RAILS_ROOT + '/log/processed/events.log-' + log_time + '.gz'
        begin
        Zlib::GzipReader.open(newpath) {|gz|
          newlog = gz.readlines
          gz.close
          log << "Start of events.log-" + log_time + ":\n"
          log << newlog.to_s
        }
        rescue
          nil
        end
      end
      return log.to_a
    end

    def self.create_events_logger(filepath)
      events_logfile = File.open(filepath, 'a')
      events_logfile.sync = true  #automatically flushes data to file
      return EventsLogger.new(events_logfile)
    end
  end

end
