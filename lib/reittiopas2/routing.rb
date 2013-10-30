require 'reittiopas2/util'

class Reittiopas2

# Routing module contains all needed functionality to query route information.
module Routing

  # Query the route between two coordinate points. In routing it is recommended
  # to use street addresses (their coordinates) as it is difficult for the end
  # user to know where exactly a stop is located. There might be several stops
  # with the same name that are located far away from each other (for example
  # the stop 'Sturenkatu' in Helsinki).
  #
  # @param [String, Hash] from Coordinates where route begins.
  # @param [String, Hash] to Coordinates where route ends.
  # @param [Hash] opts Optional parameters to query.
  # @return [Hash] the route between given points.
  #
  # @option opts [String] via
  # @option opts [Number] date (Current date) YYYYMMDD
  # @option opts [Number] time (Current time) HHMM
  # @option opts [String] timetype ('departure') Time of the request is either
  #   * 'departure' 
  #   * 'arrival'
  # @option opts [Number] via_time Minimum time spent at a via_point in 
  #   minutes.
  # @option opts [String] zone (No restriction) Ticket zone, possible values 
  #   are: 
  #   * 'helsinki', 
  #   * 'espoo', 
  #   * 'vantaa', 
  #   * 'whole' (Helsinki, Espoo, Kauniainen, Vantaa, Kirkkonummi and Kerava.
  #     Whole region, excluding non HSL areas),
  #   * 'region' (Helsinki, Espoo, Kauniainen and Vantaa region)
  # @option opts [String, Array<String>] transport_types ('all') Transport 
  #   types included in the request. Possible types are: 
  #   * 'all', 
  #   * 'bus', 
  #   * 'train',
  #   * 'metro', 
  #   * 'tram', 
  #   * 'service', 
  #   * 'U-line', 
  #   * 'ferry', 
  #   * 'walk' (ONLY walking)
  # @option opts [String] optimize ('default') Routing profile. Possible
  #   values: 
  #   * 'default' = (wait cost=1.0, walk cost=1.2, change cost=6),
  #   * 'fastest' = (wait cost=1.0, walk cost=1.0, change cost=0), 
  #   * 'least_transfers' = (wait cost=1.0, walk cost=1.5, change cost=20), 
  #   * 'least_walking' = (wait cost=1.0, walk cost=5.0, change cost=6)
  # @option opts [Number] change_margin (3) The minimum number of minutes
  #   between changes. Range 0-10.
  # @option opts [Number] change_cost Penalty for a change, user is rather
  #   N minutes later at the destination than changes to another vehicle. Range
  #   1-99. This parameter overrides the setting from optimize.
  # @option opts [Number] wait_cost With this parameter you can weigh wait
  #   time cost when calculating fastest route. Range 0.1 – 10.0.  This
  #   parameter overrides optimize parameter.
  # @option opts [Number] walk_speed (70) Walking speed.  m/min, range 1-500.
  # @option opts [String] detail ('normal') Detail level of the response. 
  #   Possible values: 
  #   * 'limited' = only legs are returned, 
  #   * 'normal' = intermiediate stops are returned, 
  #   * 'full' = route share coordinates are returned
  # @option opts [Number] show (3) Number of routes in the response.
  # @option opts [Number] mode_cost_|transport_type_id| Mode costs for different
  #   transport types. These settings override previous values set with
  #   transport_types-parameter. Values may range from 0.1 to 10 or it can be -1
  #   when the transport type is excluded from routing. 
  #
  #   transport_type_id in the parameter name may be any of the following:
  #   1. Helsinki internal bus lines
  #   2. trams
  #   3. Espoo internal bus lines
  #   4. Vantaa internal bus lines
  #   5. regional bus lines
  #   6. metro
  #   7. ferry
  #   8. U-lines
  #   12. commuter trains
  #   21. Helsinki service lines
  #   22. Helsinki night buses
  #   23. Espoo service lines
  #   24. Vantaa service lines
  #   25. region night buses
  #   36. Kirkkonummi internal bus lines
  #   39. Kerava internal bus lines
  def route(from, to, opts={})
    if from.class != to.class
      return {'error' => 'ArgumentError: from.class != to.class'}
    end

    if from.is_a? String
      query = route_query_from_strings(from, to)
    elsif from.is_a? Hash and from['coordinate'] and to['coordinate']
      query = route_query_from_locations(from, to)
    else
      return {'error' => 'ArgumentError: locations were not acceptable types'}
    end

    clean_opts = Util.select_keys(opts, KEYS + MODE_COSTS)
    @connection.perform_query(clean_opts.merge(query))
  end


  private


  def route_query_from_strings(from, to)
    {
      'request' => 'route',
      'from' => from,
      'to' => to
    }
  end

  def route_query_from_locations(from, to)
    {
      'request' => 'route',
      'from' => from['coordinate'],
      'to' => to['coordinate']
    }
  end

  KEYS = ['via', 'date', 'time', 'timetype', 'via_time', 'zone',
    'transport_types', 'optimize', 'change_margin', 'change_cost',
    'wait_cost', 'walk_cost', 'walk_speed', 'detail', 'show']

  MODE_COSTS = ['mode_cost_1', 'mode_cost_2', 'mode_cost_3', 'mode_cost_4',
      'mode_cost_5', 'mode_cost_6', 'mode_cost_7', 'mode_cost_7', 
      'mode_cost_8', 'mode_cost_12', 'mode_cost_21', 'mode_cost_22',
      'mode_cost_23', 'mode_cost_24', 'mode_cost_25', 'mode_cost_36', 
      'mode_cost_39']

end

end
