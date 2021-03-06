require 'reittiopas2/client'
require 'reittiopas2/geocoding'
require 'reittiopas2/routing'
require 'reittiopas2/utilities'
require 'reittiopas2/version'

class Reittiopas2
  include Geocoding
  include Routing 

  def initialize(username, password)
    @client = Reittiopas2::Client.new(username, password)
  end

  def self.base_url
    Reittiopas2::Client::BASE_URL
  end
end

