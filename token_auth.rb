require 'rack'
require 'jwt'

module Rack
  class TokenAuth
    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)
      token = nil
      #get secret to config somehow
      secret = "SECRET"

      if !env['HTTP_AUTHORIZATION'].blank?
        token = env['HTTP_AUTHORIZATION'].gsub('"','').gsub('Bearer ', '')
        if token
          begin
            token_data = JWT.decode token, secret
            body[:user] = token_data.to_json
          rescue 
            puts "DECODE ERROR"
            status = 401
          end
        else 
          puts "INVALID TOKEN"
          status = 401
        end
      else
        #This won't allow registrations so not sure what to do here.
        #puts "FAIL"
        #status = 401
        #body = "Unauthorized"
      end

      [status, headers, body]
    end
  end
end
