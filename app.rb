require 'rubygems'
require 'sinatra/base'
require 'sinatra/flash'
require 'sinatra/assetpack'
require 'sinatra/minify'
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

  set :root, File.dirname(__FILE__)

  register Sinatra::Minify
  set :js_path, 'assets/js'
  set :js_url, '/js'
  set :css_path, 'assets/css'
  set :css_url, '/css'
  register Sinatra::AssetPack
  assets do
    serve '/css', :from => 'assets/css'
    serve '/images', :from => 'assets/images'
    serve '/js', :from => 'assets/js'
    js :application, [
      'https://ajax.googleapis.com/ajax/libs/jquery/2.2.0/jquery.min.js',
      'https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.5/js/materialize.min.js',
      'https://cdnjs.cloudflare.com/ajax/libs/smooth-scroll/9.1.1/js/smooth-scroll.min.js'
    ]
    js :initialize_sc_account, [
      '/js/initialize_sc_account.min.js'
    ]
    css :application, [
      'https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.5/css/materialize.min.css',
      '/css/general.min.css'
    ]
    js_compression :jsmin # :jsmin | :yui | :closure | :uglify
    css_compression :sass # :simple | :yui | :sass | :sqwish
  end
  # Always minify
  enable :force_minify

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
      "waves-effect waves-light btn bg-purple-SC" if request.path_info == page
    end

    def check_body(page)
      "with-footer-index" if request.path_info == page
      (request.path_info == page) ? "with-footer-index" : "with-footer"
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

  # Para el formulario de contacto
  post '/send_contact' do
    source = URI(request.referer).path
    name = params[:name]
    email = params[:email]
    phone = params[:phone]
    description = params[:description]

    Mailer.send_lead(source, name, email, phone, description)
  end

  # Para el Email Capturing
  post '/send_mail_capturing' do
    source = URI(request.referer).path
    name = "Email Capturing"
    email = params[:email]
    phone = "---"
    description = "---"

    Mailer.send_lead(source, name, email, phone, description)
    redirect "/", 301
  end

  # Para el redireccionamiento de los enlaces antiguos
  get('/careers') do
   redirect "/", 301
  end

  get('/contact') do
   redirect "/getintouch", 301
  end

  get('/landings/mobile_customapp') do
    redirect "/", 301
  end

  get('/landings/mockups') do
    redirect "/", 301
  end
  
  get('/landings/responsive') do
    redirect "/", 301
  end
  
  get('/landings/webapps') do
    redirect "/", 301
  end

  get('/opensource') do
    redirect "/", 301
  end

  get('/ourprocess') do
    redirect "/#ourprocess", 301
  end

  get('/privacy') do
    redirect "/", 301
  end

  get('/portfolio/mobile') do
    redirect "http://portfolio.softwarecriollo.com/", 301
  end

  get('/portfolio/webapps') do
    redirect "http://portfolio.softwarecriollo.com/", 301
  end

  get('/services') do
    redirect "/ourservices", 301
  end
  
  get('/talks') do
    redirect "/", 301
  end

  get('/values') do
    redirect "/", 301
  end

  get('/whyus') do
    redirect "/#whyus", 301
  end
end