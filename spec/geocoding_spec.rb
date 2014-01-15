require 'spec_helper'

describe Reittiopas2::Geocoding do

  before :each do
    user = "username"
    pwd = "password"
    @reitti = Reittiopas2.new(user, pwd)

    @base_query = {'user' => user, 'pass' => pwd}
    @base_url = "http://api.reittiopas.fi/hsl/prod/"
  end

  describe "geocoding" do
    before :each do
      @city = 'Helsinki'
      @query = @base_query.merge('request' => 'geocode', 'key' => @city)
    end

    it "should perform request to API geocode endpoint." do
      stub_request(:get, @base_url).
        with(:query => @query)

      @reitti.geocode(@city)

      a_request(:get, @base_url).
        with(:query => @query).should have_been_made.once
    end

    it "should send only valid keys to API" do
      valid_opts = {
        'cities' => ["helsinki", "espoo"],
        'loc_types' => ['stop', 'address'],
        'disable_error_correction' => 0,
        'disable_unique_stop_names' => 0
      }
      
      opts_query_form = {
        "cities" => "helsinki|espoo",
        "loc_types" => "stop|address",
        "disable_error_correction" => 0,
        "disable_unique_stop_names" => 0
      }

      query = @query.merge(opts_query_form)
      opts = valid_opts.merge('not_valid_key' => 'or value')

      stub_request(:get, @base_url).
        with(:query => query)

      @reitti.geocode(@city, opts)

      a_request(:get, @base_url).
        with(:query => query).should have_been_made.once
    end

    it "should return hash of location hashes if query is success" do
      opts = {'loc_types' => 'stop'}

      json = File.new('spec/data/geocode.json')
      stub_request(:get, @base_url).
        with(:query => @query.merge(opts)).
        to_return(:body => json)

      locs = @reitti.geocode("Helsinki", opts)
      locs.should be_kind_of(Array)
      locs[0].should be_kind_of(Hash)
    end
  end
  
  describe "reverse geocoding" do
    before :each do
      @coords = '2548196,6678528'
      @query = @base_query.merge('request' => 'reverse_geocode', 
                                 'coordinate' => @coords)
    end

    it "should perform request to API reverse_geocode endpoint." do
      stub_request(:get, @base_url).
        with(:query => @query)

      @reitti.reverse_geocode(@coords)

      a_request(:get, @base_url).
        with(:query => @query).should have_been_made.once
    end

    it "should send only valid keys to API" do
      valid_opts = {
        'coordinate' => '2552335,6673660',
        'limit' => 1,
        'radius' => 1000,
        'result_contains' => 'stop'
      }

      opts_query_form = {
        "coordinate" => "2552335,6673660",
        "limit" => 1,
        "radius" => 1000,
        "result_contains" => "stop"
      }

      opts = valid_opts.merge('not_valid_key' => 'or value')
      query = @query.merge(opts_query_form)

      stub_request(:get, @base_url).
        with(:query => query)

      @reitti.reverse_geocode(@coords, opts)

      a_request(:get, @base_url).
        with(:query => query).should have_been_made.once
    end

    it "should return hash of location hashes if query is success" do
      json = File.new('spec/data/reverse_geocode.json')
      stub_request(:get, @base_url).
        with(:query => @query).
        to_return(:body => json)

      locs = @reitti.reverse_geocode(@coords)
      locs.should be_kind_of(Array)
      locs[0].should be_kind_of(Hash)
    end
  end
end
