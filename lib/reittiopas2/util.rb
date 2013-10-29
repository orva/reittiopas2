class Reittiopas2

module Util

  def self.select_keys(hash, keys)
    hash.select do |key, value|
      keys.include? key
    end
  end

end

end
