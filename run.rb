require 'rubygems'
require 'logger'
require 'tweetstream'
require 'lib/car'
require 'pp'

if ENV['http_proxy']
  puts 'setting proxy'
  require 'socksify'
  TCPSocket::socks_server = "socks-gw.reith.bbc.co.uk"
  TCPSocket::socks_port = 1085
  TCPSocket::socks_ignores = 'localhost'
end

if __FILE__ == $0
  Thread.abort_on_exception = true
  
  mutex = Mutex.new
  logger = Logger.new("log/#{Time.now.strftime('%Y%m%d-%H%M%S')}.log")
  hashtag = 'bbcr1race'
  cars = [
    Car.new(:one, 'scott_mills'), 
    Car.new(:two, 'mistajam')
  ]
  cars.each { |car| car.speed = :slowest; car.speed = :off }
  
  Thread.new do
    while true do
      cars.each do |car|
        mutex.synchronize { car.queue -= car.distance_moved }
        car.update_speed
      end
      sleep Car::INTERVAL
    end
  end.run
  
  config = YAML::load(File.open('config/twitter.yml'))
  TweetStream::Client.new(config['username'],config['password']).track(hashtag) do |status|
    logger.info(status.inspect)
    cars.each do |car|
      if car.matches(status.text)
        mutex.synchronize do 
          car.queue += 1
          car.tweets += 1
        end
      end
    end
  end
end
