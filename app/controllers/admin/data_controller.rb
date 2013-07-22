require "rubygems"
require "qpid"
#require 'yajl'

class Admin::DataController < ApplicationController
#class Admin::DataController < ApplicationController
  
  EMPTY_HEADER = {}
  
  def index
    data_helper
  end
  
  def create
    # data_helper
  end

  protected

  def connect
    spec = "#{Gem.loaded_specs['colinsurprenant-qpid'].full_gem_path}/specs/official-amqp0-8.xml"
    host = APP_CONFIG['host']
    port = 5672
    vhost = '/'
    user = 'guest'
    pass = 'guest'
            
    puts("connecting to #{host}:#{port} on vhost #{vhost} with user=#{user}, pass=#{pass}")

    client = Qpid::Client.new(host, port, Qpid::Spec::Loader.build(spec), vhost)
    client.start({ "LOGIN" => user, "PASSWORD" => pass })
    channel = client.channel(1)
    channel.channel_open
    
    return channel, client
  end
  
  def close(channel, client)
    puts("closing channel and client")

    channel.channel_close
    client.close
  end
  
  # pass params as name|value pair
  def publish(start_date, end_date, vendor, columns, email, all)
    channel, client = connect
    routing_key = APP_CONFIG['routing_key']
    # Prepare data
    # data = "python export_report.py -p 'applicationinfo.server_date, applicationinfo.ip, applicationinfo.xv, deviceinsertion.uuid, deviceinsertion.i, installationinfo.ii' -k 'uuid, project_id' --startdate=2010-06-08 --enddate=2010-06-08 -o 2010-new-file.csv"
    # data = "python export_report.py -p '" + columns + "' -k 'uuid, project_id' --startdate=" + start_date + " --enddate=" + end_date + " --email=" + email   
    all["language"] = "python"
    all["filename"] = "export_report.py"
    all["project"] = APP_CONFIG['app_name']
    #data << "python export_report.py "
    if (columns == nil)
      return false, "Columns is null!"
    end

    # Comment out default JSON serialization
    data = all.to_json

    # Use Yajl library to encode JSON
    #data = Yajl::Encoder.encode(all)
    
    # Rails.logger.warn "Begin connection - data"
    puts "Begin connection - " + data
    c = Qpid::Content.new(EMPTY_HEADER, data)
    channel.basic_publish(:routing_key => routing_key, :content => c, :exchange => "amq.direct")
    
    puts "End connection"
    close(channel, client)
    return true
  end

  def checkParams(start_date, end_date, vendor, columns, email, msg)
    # Vendor validation
    if (vendor == nil)
      puts msg + "Get in vendor == nil\n"
      return false, "vendor is a required parameter!\n"
    end
    # Column validation
    if (columns == nil)
      puts msg + "Get in columns == nil\n"
      return false, "Column is a required parameter!\n"
    end
    if (columns == "")
      puts msg + "Get in columns == empty string\n"
      return false, "Column is a required parameter!\n"
    end
    # start_date validation
    if((start_date != nil) and (start_date =~ /\"\d\d\d\d-\d\d-\d\d\"/))
        puts msg + "Start date is incorrect!\n"
        return false, "Start date is incorrect!\n"
    end
    
    # end_date validation
    if((end_date != nil) and (end_date =~ /\"\d\d\d\d-\d\d-\d\d\"/))
     	puts msg +  "End date is incorrect!\n"
      	return false, "End date is incorrect!\n"
    end
    
    # Email validation
    # RFC 2822 - http://www.regular-expressions.info/email.html
    #unless email =~ /[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])/
    #unless email =~ /[a-z0-9!#%&'*+=?^_`{|}~-]+(?:\.[a-z0-9!#%&'*+=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])/
    if (email == nil)
      puts msg + "Get in email == nil\n"
      return false, "Email is a required parameter!\n"
    end
    if (email == "")
      puts msg + "Get in email == empty string\n"
      return false, "Email is a required parameter!\n"
    end
    if ((email != nil) && (email =~ /\"[a-z0-9!#%&'*+=?^_`{|}~-]+(?:\.[a-z0-9!#%&'*+=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])\"/))
        return false, "Email is incorrect!\n"
    end
    
    return true, msg + "All arguements are correct!\n"
  end 
  
  def data_helper
    success = false
    msg = String.new()
    start_date, end_date, vendor, columns, email, all = nil
    start_date = params[:start_date]
    end_date = params[:end_date]
    vendor = params[:c_48]
    columns = params[:columns]
    email = params[:email]
    params.delete("controller")
    # print out HTTP POST requests
    # puts "Request values are listed below" 
    # puts "start_date = " + start_date         
    # puts "end_date = " + end_date         
    # puts "vendor = " + vendor         
    # puts "email = " + email + "\n"  
    msg = "Request values are listed below\n"
    if (start_date != nil)
    	msg = msg + "start_date = " + start_date + "\n"
    else
	msg = msg + "No start_date is passed!\n"
    end
    if (end_date != nil)
    	msg = msg + "end_date = " + end_date + "\n"
    else
	msg = msg + "No end_date is passed!\n" 
    end
    if (vendor != nil) 
    	msg = msg + "vendor = " + vendor + "\n"
    else
	msg = msg + "No vendor is passed!\n"
    end
    if (email != nil)	
    	msg = msg + "email = " + email + "\n"
    else
	msg = msg + "No email is passed!\n"
    end 
    msg = msg + "------------------------------\n"
 
    # success = start_date!=nil && end_date!=nil && columns!=nil && email!=nil  
    #success, msg = checkParams(start_date, end_date, vendor, columns, email)
    success, msg = checkParams(start_date, end_date, vendor, columns, email, msg)
    puts msg
    begin
      if success
        # Call RabbitMQ
        # publish(start_date, end_date, columns, email, where) 
        publish(start_date, end_date, vendor, columns, email, params)
        render :text => { :success => true }.to_json, :status => 200
      else
        # only send false if we want the client to retry sending data
        # render :json => { :success => false, :error_code => 400, :error_msg=>"missing parameters" }, :status => 400
        render :text => { :success => false, :error_code => 400, :error_msg=> msg }.to_json, :status => 200
      end
    
    rescue
      render :text => { :success => false, :error_code => 500, :error_msg=>"unknown errors" }.to_json, :status => 200
    end
  end # end of data_helper
end
