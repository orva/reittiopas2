class Reittiopas2

module Util

  # Converts array values into string values containing array members joined
  # by pipe ('|') characters.
  #
  # @param [Hash] a hash
  # @return [Hash] a hash
  def self.convert_array_values(hash)
    result = hash.map do |key, value|
      if value.is_a? Array
        [key, value.join('|')]
      else
        [key, value]
      end
    end

    Hash[result]
  end

  def self.select_keys(hash, keys)
    hash.select do |key, value|
      keys.include? key
    end
  end

end

end
