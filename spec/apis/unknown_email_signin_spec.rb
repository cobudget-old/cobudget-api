require 'api_helper'

describe 'Visitor creates a new group', :type => :api do
  it 'try to login without confirmation' do
    post 'api/v1/users', JSON.parse('{"user":{"email":"creator@group2.com"}}')
    expect(last_response.status).to eq(200)
    post '/api/v1/auth/sign_in', JSON.parse('{"email":"creator@group2.com","password":"wrong"}')
    puts last_response
    puts last_response.body  
  end

  it 'uses an unknown email' do
    post 'api/v1/users', JSON.parse('{"user":{"email":"creator@group3.com"}}')
    expect(last_response.status).to eq(200)
    post '/api/v1/auth/sign_in', JSON.parse(last_response.body)
    puts last_response
    puts last_response.body
  end
end