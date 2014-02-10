require 'playhouse/context'
require 'cobudget/entities/user'

module Cobudget
  module Users
    class Authenticate < Playhouse::Context
      actor :email
      actor :password

      def perform
        puts actors.inspect
        User.find_by_email(email)
      end 
    end 
  end 
end

