require 'reittiopas2/util'

class Reittiopas2

# Module containing public API to perform geocoding and reverse geocoding
# operations.
#
# Location info returned from geocode methods is following form:
# @example geocode location info
#   [ 
#     {
#       'locType' => 'stop',
#       'locTypeId' => '10',
#       'name' => 'Elielinaukio',
#       'matchedName' => 'Elielinaukio', 
#       'lang' => 'fi',
#       'city' => 'Helsinki',
#       'coords' => '2552335,6673660',
#       'details' => {
#           'address' => 'Elielinaukio',
#           'code' => '1020128',
#           'shortCode' => '2020',
#           'lines' => [
#               '1015A 1:Länsiterminaali',
#               '1015A 2:Elielinaukio'
#           ]
#       }
#     }
#   ]
#
#
# @example reverse_geocode location info
#   [ 
#     {
#       'locType' => 'address',
#       'locTypeId' => '900',
#       'name' => 'Purotie 8, Helsinki',
#       'matchedName' => nil, 
#       'lang' => 'fi',
#       'city' => 'Helsinki',
#       'coords' => '2552335,6673660',
#       'distance' => '38.4187454245971',
#       'details' => {
#           'address' => nil,
#           'houseNumber' => '8',
#       }
#     }
#   ]
#
module Geocoding

  # Search for information about place.
  #
  # @param [String] place_name the name of place to be searched. This can be
  #   street name, point of interest, bus stop, etc.
  # @param [Hash] opts the optional parameters which can be used to alter search
  #   results. Any invalid keys are removed from query parameters, but values
  #   are never checked.
  #
  # @option opts [String] 'cities' ('all') List of cities which are accepted.
  # @option opts [String] 'loc_types' ('all') List of location types which are
  #   accepted.
  # @option opts [Integer] 'disable_error_correction' (0) Disable levenshtein 
  #   error correction. 1 = Error correction NOT in use, 0 = error correction in
  #   use.
  # @option opts [Integer] 'disable_unique_stop_names' (1) Disable unique stop
  #   names in the result. 1 = all stops are shown in the result, 0 = only one
  #   stop is included in the result for stops with same name.
  #
  # @return [Array<Hash>] array containing location hashes matched given query.
  # @see #reverse_geocode
  def geocode(place_name, opts={})
    clean = Util.select_keys(opts, GEOCODE_KEYS)
    query = {'request' =>'geocode', 'key' => place_name}.merge(clean)
    @connection.perform_query(query)
  end

  # Do reverse geocode search to find information about given coordinates.
  #
  # @param [String] coords the coordinate pair "<x_coordinate>,<y_coordinate>"
  # @param [Hash] opts the optional parameters which can be used to alter query
  #   results. Any invalid keys are removed from query parameters, but values
  #   are never checked.
  #
  # @option opts [Integer] 'limit' (1) Limit for the number of locations
  #   returned. 
  # @option opts [Integer] 'radius' (1000) Radius of the search in meters. Range
  #   1-1000.
  # @option opts [String] 'result_contains' ('address') Limit the search to
  #   given location types. Possible values are: address, stop, poi
  #
  # @return [Array<Hash>] array containing location hashes matching given
  #   coordinates.
  # @see #geocode
  def reverse_geocode(coords, opts={})
    clean = Util.select_keys(opts, REVERSE_GEOCODE_KEYS)
    query = {'request' => 'reverse_geocode', 'coordinate' => coords}.merge(clean)
    @connection.perform_query(query)
  end

  GEOCODE_KEYS = ['key', 'cities', 'loc_types', 'disable_error_correction',
    'disable_unique_stop_names']

  REVERSE_GEOCODE_KEYS = ['coordinate', 'limit', 'radius', 'result_contains']

end


end
