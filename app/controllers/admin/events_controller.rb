class Admin::EventsController < Admin::LogController

  def index
#    log_index(EVENTS_PATH, true)
    tail_log(EVENTS_PATH)
  end

end
