require 'rack'
require 'jwt'

module Rack
  class TokenAuth
    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, response = @app.call(env)
      token = nil
      #get secret to config somehow
      secret = "SECRET"

      if !env['HTTP_AUTHORIZATION'].blank?
        token = env['HTTP_AUTHORIZATION'].gsub('"','').gsub('Bearer ', '')
        if token
          begin
            #I would like to return this as the body or part of it...
            #THIS CHECKS AUTHORIZATION WHEN THERE IS A TOKEN IN THE HEADERS
            token_data = JWT.decode token, secret
            puts env["REQUEST_PATH"]
            puts /.*authenticate/.match(env["REQUEST_PATH"]) != nil
          rescue 
            puts "DECODE ERROR"
            return [
              401, { "Content-Type" => "application/json" },
              [ { status: 401, error: "Auth error" }.to_json ]
            ]
          end
        else 
          puts "INVALID TOKEN"
          return [
            401, { "Content-Type" => "application/json" },
            [ { status: 401, error: "Auth error" }.to_json ]
          ]
        end
      else
        #SO WE DONT HAVE A TOKEN YET
        response
        #This won't allow registrations so not sure what to do here.
        #puts "FAIL"
        #status = 401
        #body = "Unauthorized"
      end

      puts headers
      [status, headers, response]
    end
  end
end
