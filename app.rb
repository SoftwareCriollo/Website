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
  assets do
    serve '/images', :from => 'app/assets/images'

    serve '/js', :from => 'app/assets/javascripts'
    js :application, [
      '/js/jquery-2.2.0.min.js',
      '/js/materialize.min.js',
      '/js/bootstrap.min.js',
      '/js/smooth-scroll.min.js',
      '/js/all-initialized.min.js'
    ]

    js :sc_account, [
      '/js/adroll.min.js',
      '/js/google-analytics.min.js'
    ]

    js :ie_nine, [
      '/js/html5shiv.min.js',
      '/js/respond.min.js'
    ]    

    serve '/css', :from => 'app/assets/stylesheets'
    css :application, [
      '/css/animate.min.css',
      '/css/materialize.min.css',
      '/css/main.min.css'
    ]

    js_compression :jsmin # :jsmin | :yui | :closure | :uglify
    css_compression :sass # :simple | :yui | :sass | :sqwish
  end

  set :root, File.dirname(__FILE__)

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
    slim :"index", layout: :"layout", locals: { technologies: Some.technologies, photos_our_team: Some.photos_our_team }
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

  # Para el redireccionamiento de los enlaces antiguos
  get('/contact') do
   redirect "/getintouch", 301
  end

  get('/whyus') do
    redirect "/#whyus", 301
  end

  get('/ourprocess') do
    redirect "/#ourprocess", 301
  end

  get('/portfolio/webapps') do
    redirect "http://portfolio.softwarecriollo.com/", 301
  end

  get('/services') do
    redirect "/ourservices", 301
  end

end