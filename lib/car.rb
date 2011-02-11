class Car
  attr_reader :search
  attr_accessor :queue, :speed, :tweets
  
  RELAYS = {
    :one => ['d1','d2','d3','d4'],
    :two => ['d5','d6','d7','d8']
  }
  SPEED_SETTINGS = {    # 20 10 5
    :slowest =>         [0,0,0], # 35
    :slow =>            [0,0,1], # 30
    :medium =>          [0,1,0], # 25
    :fast =>            [0,1,1], # 20
    :faster =>          [1,0,0], # 15
    :eleven =>          [1,0,1], # 10
    :outofthisworld =>  [1,1,0], # 5
  }
  INTERVAL = 1
  SPEEDS = {
    :off      => 0,
    :slowest  => 0.1,
    :slow     => 0.2,
    :medium   => 0.3,
    :fast     => 0.4,
    :faster   => 0.5,
    :eleven   => 0.6,
    :outofthisworld => 1
  }
  
  def initialize(number, *search)
    @search = search
    @relay_keys = RELAYS[number]
    
    @speed = :off
    @queue = 0.0
    @tweets = 1
  end
  
  def matches(text)
    return false if text.nil?
    result = false
    search_string = text.downcase
    search.each { |s| result = true if search_string =~ /#{s}/ }
    result
  end
  
  def distance_moved
    (SPEEDS[self.speed] * INTERVAL)
  end
  
  def update_speed
    self.speed = case queue
      when 0 then :off
      when 0..50 then :slowest
      when 50..200 then :slow
      when 200..500 then :medium
      when 500..600 then :fast
      when 500..1000 then :faster
      when 200..250 then :eleven
      else :outofthisworld
    end
    puts "---------> #{search}\t(#{tweets})\t#{queue}\t#{speed}"
    speed
  end
  
  def queue=(queue)
    @queue = queue
    @queue = 0.0 if (@queue < 0.0)
    @queue
  end
  
  def speed=(speed)
    return if (@speed == speed)
    params = {}
    relays = (speed == :off) ? [0,0,0,0] : [1] + SPEED_SETTINGS[speed].reverse
    @relay_keys.each_with_index { |r, i| params[r] = relays[i] }
    url = URI.parse('http://localhost:8055/outputs')
    Net::HTTP.post_form(url, params)
    @speed = speed
  end
end
