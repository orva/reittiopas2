require "spec_helper"

describe Reittiopas2 do
  before :each do
    @user = "username"
    @pwd = "password"
    @reitti = Reittiopas2.new @user, @pwd
  end


  describe "base_api_url" do
    it "returns base uri which query can be appended." do
      val = @reitti.base_api_url
      exp = "http://api.reittiopas.fi/hsl/prod/?user=#{@user}&pass=#{@pwd}"
      val.should == exp
    end
  end
end
