require './env' if File.exists?('env.rb')
require './app'

map '/' do
 run App
end