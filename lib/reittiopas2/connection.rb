class Reittiopas2

class Connection

  def initialize(username, password)
    @base_url = "http://api.reittiopas.fi/hsl/prod/"
    @base_query = {"user" => username, "pass" => password}
  end


  def perform_query(query={})
    query = fix_arrays(query)
    # uri = URI(@base_url)
    # uri.query = URI.encode_www_form @base_query.merge(query)
    # uri.query = create_query_string @base_query.merge(query)
    # uri_str = @base_url << "?" << create_query_string(@base_query.merge(query))
    # uri = URI.parse(uri_str)
    uri = Addressable::URI.parse(@base_url)
    uri.query_values = @base_query.merge(query)

    res = Net::HTTP.get_response(uri)

    if res.code == '500'
      # In case of errors, code 500 is returned and there is explanation in
      # response body as HTML.
      {'error' => res.body}
    elsif res.body
      JSON.load res.body.to_s
    else
      {'error' => "Response body was empty!"}
    end
  rescue JSON::ParserError => ex
    {'error' => ex.class}
  end


  private


  def create_query_string(query)
    retval = ""
    query.each do |key, val|
      retval << key << "=" << val << "&"
    end

    retval[0..-2] # Remove last '&'
  end

  def fix_arrays(query)
    retval = {}
    query.each do |key, val|
      if val.is_a? Array
        retval[key] = array_to_query_form(val)
      else
        retval[key] = val
      end
    end
    retval
  end


  def array_to_query_form(arr)
    raise(ArgumentError, "arr is not Array") unless arr.is_a? Array

    retval = ""
    arr.each do |val|
      retval << val << "|"
    end

    retval[0..-2] # Remove last pipe
  end
end

end
