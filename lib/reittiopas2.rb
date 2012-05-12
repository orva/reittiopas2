require "net/http"
require "json"

require "reittiopas2/version"

require "reittiopas2/connection"

class Reittiopas2

  def initialize(username, password)
    @connection = Reittiopas2::Connection.new(username, password)
  end
end

