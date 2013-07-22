module AnalyticsLogger
  module Error
    BadVersionError = Class.new(StandardError)
    MissingParamsError = Class.new(StandardError)
    BadTokenError = Class.new(StandardError)
  end
end