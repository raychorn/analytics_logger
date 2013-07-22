require File.dirname(__FILE__) + '/../spec_helper'

describe Event do
  before(:each) do
  end
  
  it 'writes event to log file' do
    request = 
    params = ""
    iter = 1000
    keylen = 48
    salt_charlen = 16
    Event.writeLog(request, params, iter, keylen, salt_charlen)
  end
end