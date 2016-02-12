require 'rubygems'
require 'sinatra/base'
require 'sinatra/flash'
require 'sinatra/assetpack'
require 'slim'
require 'pony'
require 'sass'
require 'haml'
require "sinatra/content_for"
require 'mail'

class App < Sinatra::Base
  enable :method_override
  set :environment, :development
  enable :sessions

  configure(:development) { set :session_secret, "something" }
  configure(:production) { set :session_secret, "IaRBmHDz" }
  register Sinatra::Flash

  register Sinatra::AssetPack
  set :root, File.dirname(__FILE__)
  Slim::Engine.set_options :sections => false

  ['app/models/**/*'].each do |dir_path|
    Dir[dir_path].each { |file_name| require "./#{file_name}"}
  end

  set :public_folder, File.join(File.dirname(__FILE__), 'public')
  set :views, File.join(File.dirname(__FILE__), 'views')
  set :static_cache_control, [:public, max_age: 60 * 60 * 24 * 30 ]

  helpers do
    def partial(page, options={})
      haml page, options.merge!(:layout => false)
    end

    def partial(page, options={})
      slim page, options.merge!(:layout => false)
    end

    def erb_partial(page,options={})
      erb page, options.merge!(:layout => false)
    end

    def blog_slim(page)
      slim page, layout: :layout_post
    end

    def cp(page)
      "waves-effect waves-light btn bgSC" if request.path_info == page
    end
  end

  helpers Sinatra::ContentFor

  get('/') do
    slim :"index", :layout => :"layout"
  end

  get('/getintouch') do
    slim :"getintouch", :layout => :"layout"
  end

  get('/ourservices') do
    slim :"ourservices", :layout => :"layout"
  end

  post '/send_contact' do
    source = URI(request.referer).path
    name = params[:name]
    email = params[:email]
    phone = params[:phone]
    description = params[:description]

    Mailer.send_lead(source, name, email, phone, description)
  end

end