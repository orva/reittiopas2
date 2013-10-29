require "reittiopas2/version"

require "reittiopas2/connection"
require "reittiopas2/geocoding"
require "reittiopas2/routing"

class Reittiopas2
  include Geocoding
  include Routing 

  def initialize(username, password)
    @connection = Reittiopas2::Connection.new(username, password)
  end
end

