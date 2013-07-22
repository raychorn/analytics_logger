require "rubygems"

# Feature: Upload files to the server by using HTTP POST requests.
# Description: This feature initially is for the PCAP project
# Usages: 
# $curl -F file=@C:\test.txt http://10.100.162.63:8082/files
# $curl -k -F file=@test.txt https://sprintcm.analytics.smithmicro.com/files

class FilesController < ApplicationController

  EMPTY_HEADER = {}
  
  def create
    input_file, file_name, output_file, msg = nil
    input_file = params[:file] # input_file is a File object which has file name & data
    
    file_name = input_file.original_filename # return File.basename(input_file_name)
    # check if input_file exists
    if File.exists?(input_file)
      puts file_name + " exists"
    else
      puts file_name + " does not exist"
      msg = "http 404 - file not found"
      render :text => { :success => false, :error_code => 404, :error_msg=> msg }.to_json, :status => 200
    end
    
    # the target file
    output_file = "#{RAILS_ROOT}/public/files/#{file_name}"
    
    # write to the target file in bytes
    File.open(output_file, "wb") do |f|
      f.write(input_file.read)
    end
    
    # render :text => { :success => true }.to_json
    render :text => { :success => true }.to_json, :status => 200
  end

=begin
  def scp_file(user, host, directory, file_name)
      cmd = "scp " + file + " " + user + "@" + host + ":" + directory + file_name
      # puts cmd
      system(cmd)
  end
=end

end
