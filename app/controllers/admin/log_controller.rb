require 'shellwords'

class Admin::LogController < ApplicationController
  # Require ssl
  # ssl_required :create, :index

  # Allow ssl or non-ssl
  ssl_allowed :index

  # TODO: make clear events button
  # TODO: secure
  
  def tail_log (log_path)
    @total_entries = params[:total_entries] || 50
    @total_entries = @total_entries.to_i
    @total_entries = 50 if @total_entries <= 0
    tail_lines = `tail -n #{@total_entries} #{log_path.shellescape}`
    @view_status = "Most Recent #{@total_entries} Lines"
    @page_results = tail_lines.split("\n")
  end
  
  def log_index (log_path, compressed)
    @per_page = 50
    if params[:per_page]
      @per_page = Integer(params[:per_page])
    end
    @total_entries = 0
    if !compressed
      @lines = AnalyticsLogger::LogHelper.read(log_path)
    elsif params[:e_date] && params[:e_date].size > 0
      time = Time.now
      @view_status = "Log files starting from #{params[:e_date]} to #{time.strftime("%Y-%m-%d")}"
      @lines = AnalyticsLogger::EventsHelper.read_compressed_events_date(params[:e_date]) + AnalyticsLogger::LogHelper.read(log_path)
    else
      @view_status = "Past 5 Days of Log Files"
      @lines = AnalyticsLogger::EventsHelper.read_compressed_events() + AnalyticsLogger::LogHelper.read(log_path)
    end
    if @lines.present?
      @total_entries = @lines.length
      @array = @lines.to_a
      @page = params[:page]
      @page = 'last' if @page == nil
      if (@page == 'last')
        page_ind = (@total_entries - 1) / @per_page + 1        
      else
        page_ind = @page
      end
      @page_results = @array.paginate(:page => page_ind, :per_page => @per_page)
    else
      @page_results = [].paginate
    end
  end
  
  def rotate
    success = AnalyticsLogger::LogHelper.rotate(EVENTS_PATH)
    if success
      render :json => { :success => true }.to_json, :status => 200
    else
      render :json => { :success => false, :error_code => 409, :error_msg=> 'rotation not needed or hadoop missing' }.to_json, :status => 409
    end
  end
end
