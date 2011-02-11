require 'rake'
require "rspec/core/rake_task"

require 'lib/car'

desc "Run all examples"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = %w[--color]
  t.verbose = false
end

namespace :cars do
  desc "off"
  task :off do
    cars.each { |car| car.speed = :off }
  end

  cars = [Car.new(:one), Car.new(:two)]

  Car::SPEEDS.keys.each do |speed|
    desc "Set cars to: #{speed}"
    task speed do
      cars.each { |car| car.speed = speed }
    end
  end
end

desc "Parse tweets"
task :parse_tweets do |tweet|
  File.open('log/merged.log').each do |line|
    tweet = $1 if line =~ /:text=>"(.+?)"/
    puts tweet.downcase
  end
end
