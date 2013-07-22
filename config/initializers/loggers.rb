EVENTS_PATH = RAILS_ROOT + '/log/events.log'
EVENTS_LOGGER = AnalyticsLogger::EventsHelper.create_events_logger(EVENTS_PATH)
