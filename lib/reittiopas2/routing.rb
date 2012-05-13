
class Reittiopas2

module Routing
  def route(from, to)
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

    @connection.perform_query(query)
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
end

end
