module DiverseHelpers
  def set_default_str(string, default)
    if string.respond_to?(:to_s)
      string == '' || string == nil || string =~ /\a\s*\z/ ? default.to_s : string
    else
      default
    end
  end

  def set_default_int(integer, default)
    if integer.respond_to?(:to_i)
      if integer == nil || !integer.instance_of?(Fixnum)
        default.to_i
      else
        integer
      end
    else
      default
    end
  end

  def truncate(string, length, *ellipsis)
    ellipsis = ellipsis[0] || '...'
    if string.length > length
      string[0..length].gsub(/\n/, ' ') + ellipsis
    else
      string
    end
  end

  def truncate_keep_newline(string, length, *ellipsis)
    ellipsis = ellipsis[0] || '...'
    if string.length > length
      string[0..length] + ellipsis
    else
      string
    end
  end
end
