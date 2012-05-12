require "spec_helper"

describe Reittiopas2::Connection do
  before :each do
    @user = "username"
    @pwd = "password"
    @conn = Reittiopas2::Connection.new @user, @pwd

    @base_url = "http://api.reittiopas.fi/hsl/prod/"
    @query = {"user" => @user, "pass" => @pwd}
  end



  describe "query forming" do
    it "should put pipes into arrays" do
      q = @query.merge({ "array" => ["one", "two", "three"] })
      expected_q = @query.merge({ "array" => "one|two|three"})

      stub_request(:get, @base_url).
        with(:query => expected_q)

      @conn.perform_query(q)
      a_request(:get, @base_url).with(:query => expected_q).should have_been_made
    end


    it "should form query only with credentials in case no query given." do
      stub_request(:get, @base_url).
        with(:query => @query)

      @conn.perform_query
      a_request(:get, @base_url).with(:query => @query).should have_been_made
    end
  end


  describe "perform_query return value" do
    it "should be hash filled with data in case of succesful query." do
      body = '{"max":5000,"used":44}'
      query = @query.merge({ "request" => "stats" })

      stub_request(:get, @base_url).
        with(:query => query).
        to_return(:body => body)

      ret = @conn.perform_query(query)
      ret.should == {"max" => 5000, "used" => 44}
    end


    it "should have response body in error field in case of 500 code" do
      body = "Hello! Error!"

      stub_request(:get, @base_url).
        with(:query => @query).
        to_return(:status => 500, :body => body)

      ret = @conn.perform_query
      ret.should == {'error' => body}
    end


    it "should error field in case of JSON parse error" do
      body = "well this is not valid JSON"

      stub_request(:get, @base_url).
        with(:query => @query).
        to_return(:body => body)

      ret = @conn.perform_query
      ret['error'].should_not be_nil
    end

  end
end
