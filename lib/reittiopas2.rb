require "net/http"
require "json"

require "reittiopas2/version"

require "reittiopas2/connection"
require "reittiopas2/geocoding"

class Reittiopas2
  include Geocoding

  def initialize(username, password)
    @connection = Reittiopas2::Connection.new(username, password)
  end
end

