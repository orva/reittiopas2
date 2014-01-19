class Reittiopas2

module Utilities
  module_function

  # Converts array values into string values containing array members joined
  # by pipe ('|') characters.
  #
  # @param [Hash] a hash
  # @return [Hash] a hash
  def convert_array_values(hash)
    result = hash.map do |key, value|
      if value.is_a? Array
        [key, value.join('|')]
      else
        [key, value]
      end
    end

    Hash[result]
  end

  def select_keys(hash, keys)
    hash.select do |key, value|
      keys.include? key
    end
  end

end

end
