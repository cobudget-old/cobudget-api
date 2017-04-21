require 'rails_helper'
require 'rack/test'

module ApiHelper
  include Rack::Test::Methods

  def app
    Rails.application
  end
end

RSpec.configure do |config|
  config.include ApiHelper, :type => :api
end