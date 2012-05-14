require "spec_helper"

describe Reittiopas2::Routing do
  before :each do
    user = "username"
    pass = "password"
    @reitti = Reittiopas2.new(user, pass)

    @base_query = {'user' => user, 'pass' => pass}
    @base_url = "http://api.reittiopas.fi/hsl/prod/"
  end

  describe "route fetching" do
    before :each  do
      @from = '2546445,6675512'
      @to = '2549445,6675513'
      @query = @base_query.merge('request' => 'route',
                                 'from' => @from,
                                 'to' => @to)
    end

    it "should accept coordinates as strings." do
      stub_request(:get, @base_url).
        with(:query => @query)

      @reitti.route(@from, @to)
      a_request(:get, @base_url).
        with(:query => @query).should have_been_made.once
    end

    it "should accept location hashes as coordinates." do
      from_hash = {'coordinate' => @from}
      to_hash = {'coordinate' => @to}

      stub_request(:get, @base_url).
        with(:query => @query)

      @reitti.route(from_hash, to_hash)
      a_request(:get, @base_url).
        with(:query => @query).should have_been_made.once
    end

    it "should reject hashes without coordinates." do
      from_hash = {'fake' => @from}
      to_hash = {'fake' => @to}

      ret = @reitti.route(from_hash, to_hash)
      ret['error'].should == 'ArgumentError: locations were not acceptable types'
    end

    it "should reject coordinates which are different types." do
      from_hash = {'fake' => @from}
      ret = @reitti.route(from_hash, @to)
      ret['error'].should == 'ArgumentError: from.class != to.class'
    end

    # This test works because we are not checking values, only keys
    it "should reject keys that are not valid query parameters" do
      keys = ['via', 'date', 'time', 'timetype', 'via_time', 'zone',
        'transport_types', 'optimize', 'change_margin', 'change_cost', 
        'wait_cost', 'walk_cost', 'walk_speed', 'detail', 'show'] 
      mode_costs = ['mode_cost_1', 'mode_cost_2', 'mode_cost_3', 'mode_cost_4',
        'mode_cost_5', 'mode_cost_6', 'mode_cost_7', 'mode_cost_7', 
        'mode_cost_8', 'mode_cost_12', 'mode_cost_21', 'mode_cost_22',
        'mode_cost_23', 'mode_cost_24', 'mode_cost_25', 'mode_cost_36', 
        'mode_cost_39']

      opts = {}
      keys.each { |key| opts[key] = "_" }
      mode_costs.each { |key| opts[key] = "_" }

      query = @query.merge(opts)
      stub_request(:get, @base_url).
        with(:query => query)

      invalid = query.merge('not valid' => 'at all')
      @reitti.route(@from, @to, invalid)

      a_request(:get, @base_url).
        with(:query => query).should have_been_made.once
    end
  end
end
