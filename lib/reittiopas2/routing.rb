
class Reittiopas2

module Routing
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

    clean_opts = route_remove_invalid_keys(opts)
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

  def route_remove_invalid_keys(opts)
    keys = ['via', 'date', 'time', 'timetype', 'via_time', 'zone',
      'transport_types', 'optimize', 'change_margin', 'change_cost', 
      'wait_cost', 'walk_cost', 'walk_speed', 'detail', 'show'] 
    mode_costs = ['mode_cost_1', 'mode_cost_2', 'mode_cost_3', 'mode_cost_4',
      'mode_cost_5', 'mode_cost_6', 'mode_cost_7', 'mode_cost_7', 
      'mode_cost_8', 'mode_cost_12', 'mode_cost_21', 'mode_cost_22',
      'mode_cost_23', 'mode_cost_24', 'mode_cost_25', 'mode_cost_36', 
      'mode_cost_39']

    whitelist = []  
    whitelist.concat keys
    whitelist.concat mode_costs

    opts.select do |key, val|
      whitelist.include? key
    end
  end
end

end
