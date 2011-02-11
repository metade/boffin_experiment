require 'spec_helper'

describe Car do
  before(:each) do
    @car = Car.new(:one, 'foo')
  end
  
  describe "setting the queue" do
    it "should set the queue" do
      @car.queue += 1
      @car.queue.should == 1.0
    end
    
    it "should increment the queue in fractions" do
      @car.queue += 0.1
      @car.queue.should == 0.1
    end
    
    it "should keep the queue above 0" do
      @car.queue -= 1
      @car.queue.should == 0.0
    end
  end
  
  describe "updating speed" do
    it "should be 0 when the queue is empty" do
      @car.queue = 0
      @car.update_speed.should == :off
    end
    
    it "should be :slowest when the queue is 0.1" do
      @car.queue = 0.1
      @car.update_speed.should == :slowest
    end
  end
  
  describe "matching tweets" do
    before(:all) do
      @car_mills = Car.new(:one, 'scott_mills')
      @car_mistajam = Car.new(:two, 'mistajam')
    end
    
    it "should return false when no string is provided" do
      @car_mills.matches(nil).should be_false
    end
    
    it "should match a simple string" do
      @car_mills.matches('scott_mills').should be_true
    end
    
    it "should match one car when the tweet mentions that car" do
      tweet = "Here's why tomorrow you need to tweet #BBCR1RACE mistajam at about 5.10pm http://bbc.in/i9JcdN I NEED YOUR HELP!!!"
      @car_mills.matches(tweet).should be_false
      @car_mistajam.matches(tweet).should be_true
    end
    
    it "should match both cars when the tweet mentions that car" do
      tweet = "@laura_milkteeth: right so our spesh #smwldn and @bbcr1 experiment has been announced - @scott_mills VS @mistajam #BBCR1RACE http://bbc.in/9NeBIi VROOM VROOM"
      @car_mills.matches(tweet).should be_true
      @car_mistajam.matches(tweet).should be_true
    end
    
    describe "with multiple search terms" do
      before(:all) do
        @car_mills = Car.new(:one, 'scott_mills', 'scottmills', 'mills')
      end
      
      ['scottmills', 'scott mills', 'mills'].each do |text|
        it "should match '#{text}'" do
          @car_mills.matches(text).should be_true
        end
      end
      
      ['mistajam', 'scot mils', 'scott'].each do |text|
        it "should not match '#{text}'" do
          @car_mills.matches(text).should_not be_true
        end
      end
    end
  end
end
