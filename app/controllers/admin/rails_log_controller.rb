class Admin::RailsLogController < Admin::LogController
  def index
#    log_index(RAILS_ROOT + "/log/#{Rails.env}.log", false)
    tail_log(RAILS_ROOT + "/log/#{Rails.env}.log")
    render 'admin/events/index'
  end

end
