require 'reittiopas2/util'

require 'addressable/uri'
require 'json'
require 'net/http'

class Reittiopas2

# Handles connectting to Reittiopas API and transforms query hashes into form
# that Reittiopas API can digest them. This class is also responsible for
# parsing response into Ruby readable form.
#
# @api private
class Connection

  def initialize(username, password)
    @base_url = "http://api.reittiopas.fi/hsl/prod/"
    @base_query = {"user" => username, "pass" => password}
  end

 
  # Forms proper query from credentials + given query and sends it to API
  # endpoint. Also parses response into Ruby readable form.
  #
  # In case of errors, be those from API endpoint or from internal processes,
  # return value will be hash with one field 'error' which contains error
  # message.
  #
  # In fatal error situations Exception will be thrown, only exception for this
  # rule is JSON::ParserException which is caught and returned as value of
  # 'error' field.
  #
  # @param [Hash] query the query which is to be sent to API endpoint
  # @return [Hash] the whatever data was requested from API, or Hash containing
  #   key 'error' containing error message.
  def perform_query(query={})
    query = Util.convert_array_values(query)
    uri = Addressable::URI.parse(@base_url)
    uri.query_values = @base_query.merge(query)

    res = Net::HTTP.get_response(uri)

    if res.code == '500'
      # In case of errors, code 500 is returned and there is explanation in
      # response body as HTML.
      {'error' => res.body}
    elsif res.body.nil? or res.body.empty?
      {'error' => "Response body was empty!"}
    else
      JSON.load res.body.to_s
    end
  rescue JSON::ParserError => ex
    {'error' => ex.class}
  end

end

end
