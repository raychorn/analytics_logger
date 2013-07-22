module AnalyticsLogger
  class StringConverter
    def self.string_to_bytes(str)
      num_bytes = str.length / 2
  
      # The "unpack" call assumes you have num_bytes pairs of hex digits (the 'a2' bit will match a two digit hex number). Change the num_bytes to match however many hex numbers are in your string. The "map" call creates an array from the unpacked string, with the num_bytes two-digit hex numbers converted into num_bytes decimal numbers. The "pack" call takes this array of num_bytes integers and converts it into a packed stream of num_bytes bytes.
      return str.unpack('a2'*num_bytes).map{|x| x.hex}.pack('c'*num_bytes)
    end
  
    def self.bytes_to_string(bytes)
      return bytes.unpack('H*').to_s
    end
  end
end