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
      secret = "SECRET"

      if !env['HTTP_AUTHORIZATION'].blank?
        token = env['HTTP_AUTHORIZATION'].gsub('"','').gsub('Bearer ', '')
        if token
          begin
            stuff = JWT.decode token, secret
            puts stuff
          rescue 
            puts "rescue"
            status = 401
          end
        else 
          puts "INVALID TOKEN"
          status 401
        end
      else
        puts "FAIL"
        status 401
      end

      [status, headers, body]
    end
  end
end
