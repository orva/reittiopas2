class Reittiopas2


module Geocoding
  def geocode(place_name, opts={})
    clean = geocode_remove_invalid_keys(opts)
    query = {'request' =>'geocode', 'key' => place_name}.merge(clean)
    @connection.perform_query(query)
  end


  def reverse_geocode(coords, opts={})
    clean = reverse_geocode_remove_invalid_keys(opts)
    query = {'request' => 'reverse_geocode', 'coordinate' => coords}.merge(clean)
    @connection.perform_query(query)
  end


  private 


  def geocode_remove_invalid_keys(query)
    whitelist = [ 'key', 'cities', 'loc_types', 'disable_error_correction', 
      'disable_unique_stop_names' ]

    query.select do |key, val|
      whitelist.include? key
    end
  end

  def reverse_geocode_remove_invalid_keys(query)
    whitelist = [ 'coordinate', 'limit', 'radius', 'result_contains' ]

    query.select do |key, val|
      whitelist.include? key
    end
  end
end


end
