require "reittiopas2/version"

class Reittiopas2
  def initialize(username, password)
    @username = username
    @password = password
  end

  def base_api_url
    "http://api.reittiopas.fi/hsl/prod/?user=#{@username}&pass=#{@password}"
  end
end
