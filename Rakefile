# Be sure to change the values above. They assume that your main
# file is called 'init.rb' and that your Application class is called
# 'Main'.
desc "Builds the minified CSS and JS assets."
task :minify do
  #require 'app.rb'   # <= change this
  require './app'
  puts "Building..."

  files = Sinatra::Minify::Package.build(App)  # <= change this
  files.each { |f| puts " * #{File.basename f}" }
  puts "Construction complete!"
end