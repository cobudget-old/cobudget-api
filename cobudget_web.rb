$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), 'lib'))
require 'yaml'
require 'sinatra/base'
require 'playhouse/sinatra'
require 'cobudget/cobudget_play'
require 'cobudget/production'
require 'cobudget_theatre'
require 'bcrypt'

class CobudgetWeb < Sinatra::Base
  #production = Cobudget::Production.new
  #theatre = Cobudget::CobudgetTheatre.new(root: settings.root, environment: settings.environment)

  #production.run theatre: theatre, interface: Playhouse::Sinatra::Interface, interface_args: ARGV

  register Playhouse::Sinatra
  set :root,  File.expand_path(File.join(File.dirname(__FILE__)))
  routes = YAML.load_file('config/routes.yml')

  production = Cobudget::Production.new
  production.routes = routes
  theatre = Cobudget::CobudgetTheatre.new(root: settings.root, environment: settings.environment)
  #root: settings.root, environment: settings.environment

  add_play theatre, Cobudget::CobudgetPlay, routes

  #production.run(theatre: theatre, interface: nil, interface_args: ARGV )

  post '/authenticate' do
    password = params["password"]
    puts CobudgetWeb.apis['cobudget'].inspect
    puts CobudgetWeb.apis['cobudget'].methods.to_yaml
    user = CobudgetWeb.apis['cobudget'].find_by_email_users({email: params["email"]})
    encrypted_password = BCrypt::Engine.hash_secret(password, user.salt)
    puts "ENCRYPTED"
    if user and password == encrypted_password
      #get secret to config somehow
      return false
      JWT.encode({"id" => user.id}, "SECRET")
    else
      puts "Error with password or email"
      500
    end
  end

  run! if app_file == $0

  def build_cobudget_web theatre

  end
end
