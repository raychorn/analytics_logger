require 'patron'
require 'uri'

# @sess is defined in hooks.rb

#When events with version <version> are posted
When /^events with version (.*) are posted$/ do |version|
  @stamp = "test_version_#{version} #{Time.now}"
  qs_prefix = "v=#{version}&g=98de0b81-5e3c-4be2-b40c-f4e814972d86&t=80f07b369a682aa30e47cb9fb141f7a4efaa7019f3304009a82c399f3c857eb544e2ba93ce9a225ec213234e3bd6cdcce13e2d83c6144d01&data="
  qs_data = "[ 1, \"2009-09-03 21:50:11\", \"vzmmtest\", \"#{version}\", \"aaf85903-0565-42d0-b6b4-d72c19ce07d7\", 6, devices, \"#{@stamp}\" ]"
  post_data = qs_prefix + URI.escape(qs_data, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))

  @resp = @sess.post('/events', post_data)
end

When /^(valid|empty|invalid token|missing params) events are posted$/ do|event_category|
  case event_category
    when 'valid'
      @stamp = "test_valid_events #{Time.now}"
      qs_prefix = "v=v1.0.0.0&g=98de0b81-5e3c-4be2-b40c-f4e814972d86&t=80f07b369a682aa30e47cb9fb141f7a4efaa7019f3304009a82c399f3c857eb544e2ba93ce9a225ec213234e3bd6cdcce13e2d83c6144d01&data="
      qs_data = "[ 1, \"2009-09-03 21:50:11\", \"vzmmtest\", \"v0.8.0.1015\", \"aaf85903-0565-42d0-b6b4-d72c19ce07d7\", 6, devices, \"#{@stamp}\" ]"
    when 'empty'
      @stamp = "test_empty_events #{Time.now}"
      qs_prefix = "v=v1.0.0.0&g=98de0b81-5e3c-4be2-b40c-f4e814972d86&t=80f07b369a682aa30e47cb9fb141f7a4efaa7019f3304009a82c399f3c857eb544e2ba93ce9a225ec213234e3bd6cdcce13e2d83c6144d01&data="
      qs_data = ""
    when 'invalid token'
      @stamp = "test_invalid_token #{Time.now}"
      qs_prefix = "v=v1.0.0.0&g=98de0b81-5e3c-4be2-b40c-f4e814972d86&t=10f07b369a682aa30e47cb9fb141f7a4efaa7019f3304009a82c399f3c857eb544e2ba93ce9a225ec213234e3bd6cdcce13e2d83c6144d01&data="
      qs_data = "[ 1, \"2009-09-03 21:50:11\", \"vzmmtest\", \"v0.8.0.1015\", \"aaf85903-0565-42d0-b6b4-d72c19ce07d7\", 6, devices, \"#{@stamp}\" ]"
    when 'missing params'
      @stamp = "test_missing_params #{Time.now}"
      qs_prefix = "v=v1.0.0.0&t=80f07b369a682aa30e47cb9fb141f7a4efaa7019f3304009a82c399f3c857eb544e2ba93ce9a225ec213234e3bd6cdcce13e2d83c6144d01&data="
      qs_data = "[ 1, \"2009-09-03 21:50:11\", \"vzmmtest\", \"v0.8.0.1015\", \"aaf85903-0565-42d0-b6b4-d72c19ce07d7\", 6, devices, \"#{@stamp}\" ]"
  end
  post_data = qs_prefix + URI.escape(qs_data, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))

  @resp = @sess.post('/events', post_data)
end

Then /^I should get a "success=(true|false)" response$/ do |success|
  json_resp = ActiveSupport::JSON.decode(@resp.body)
  if success == 'true'
    @resp.status.should == 200
    json_resp['success'].should == true
  else
    @resp.status.should == 400
    json_resp['success'].should == false
  end
end

Then /^I should (not |)see the events in the event\.log$/ do |see|
  events = AnalyticsLogger::LogHelper.read(EVENTS_PATH)
  posted_events = events.grep(/#{@stamp}/)
  if see == 'not '    
    posted_events.size.should == 0
  else
    posted_events.size.should == 1
  end
end

Then /^I should not see a warning in the test\.log$/ do
  f = File.new("#{RAILS_ROOT}/log/#{RAILS_ENV}.log")
  log = f.readlines
  f.close
  warning_log = log.grep(/(WARN|ERROR|FATAL).*#{@stamp}/)
  warning_log.size.should == 0
end

Then /^I should see a (BAD_TOKEN|BAD_VERSION|MISSING_PARAMS) warning in the test\.log$/ do |warning|
  f = File.new("#{RAILS_ROOT}/log/#{RAILS_ENV}.log")
  log = f.readlines
  f.close
  encoded_stamp = URI.escape(@stamp, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
  warning_log = log.grep(/(WARN|ERROR|FATAL).*#{warning}.*#{encoded_stamp}/)
  warning_log.size.should == 1
end
