# converts a string version to an integer array which allows comparison of version
class Version < Array
  def initialize s
      if !Version.is_a_numerical_version?(s)
        raise AnalyticsLogger::Error::BadVersionError
      end
      super(s.split('.').map { |e| e.to_i })
  end

  def < x
    a, b = pad(self, x)
    (a <=> b) < 0
  end

  def > x
    a, b = pad(self, x)
    (a <=> b) > 0
  end
 
  def == x
    a, b = pad(self, x)
    (a <=> b) == 0
  end

  # test to make sure only contains digits and decimals
  def self.is_a_numerical_version?(s)
    # must contain at least one number, no more than one decimal in a row, and if it contains a decimal it should be followed by a digit
    s.to_s.match(/\A\d+(\.?\d+)*\z/) == nil ? false : true
  end

private
  
  # returns arrays matched to the same length, padded with 0, without modifying the original array
  # the reason we need this is because the built-in array comparison thinks [1,0,0] > [1,0]
  def pad(a, b)
    if a.length == b.length
      # do nothing
      return a, b
    elsif a.length > b.length
      y = b.dup
      y.fill(0, y.length, a.length - y.length)
      return a, y
    else
      x = a.dup
      x.fill(0, x.length, b.length - x.length)
      return x, b
    end
  end

end
