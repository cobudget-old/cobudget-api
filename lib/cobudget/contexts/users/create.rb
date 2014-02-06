require 'playhouse/context'
require 'cobudget/contexts/accounts/create'
require 'cobudget/entities/user'
require 'bcrypt'

module Cobudget
  module Users
    class Create < Playhouse::Context
      actor :name, optional: true
      actor :email
      actor :password
      actor :password_confirmation
      actor :bg_color, optional: true
      actor :fg_color, optional: true

      def perform
        if actors[:password] and actors[:password_confirmation] == actors[:password]
          actors[:salt] = BCrypt::Engine.generate_salt
          actors[:encrypted_password] = BCrypt::Engine.hash_secret(actors[:password], actors[:salt])
          data = User.create!(actors_except :password_confirmation, :password)
          data.as_json(except: [:encrypted_password, :salt])
        end
      end
    end
  end
end
