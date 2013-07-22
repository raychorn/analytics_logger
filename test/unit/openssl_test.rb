require 'test_helper'
require 'openssl'


class OpenSSLTest < ActiveSupport::TestCase

  #Guid: 98de0b81-5e3c-4be2-b40c-f4e814972d86
  #Hash: 80f07b369a682aa3 0e47cb9fb141f7a4efaa7019f3304009a82c399f3c857eb544e2ba93ce9a225ec213234e3bd6cdcce13e2d83c6144d01

  test "test_pbkdf2" do

    pass = "98de0b81-5e3c-4be2-b40c-f4e814972d86"
    salt_as_string = "80f07b369a682aa3"
    
    salt = AnalyticsLogger::StringConverter.string_to_bytes(salt_as_string)
    
    iter = 1000
    keylen = 48
    result = OpenSSL::PKCS5.pbkdf2_hmac_sha1(pass, salt, iter, keylen)
    assert result != nil
    
    result_as_string = AnalyticsLogger::StringConverter.bytes_to_string(result)
    puts result_as_string
    
    salt_out = AnalyticsLogger::StringConverter.bytes_to_string(salt)
    assert salt_as_string == salt_out
    
    assert "0e47cb9fb141f7a4efaa7019f3304009a82c399f3c857eb544e2ba93ce9a225ec213234e3bd6cdcce13e2d83c6144d01" == result_as_string
    
  end
end
