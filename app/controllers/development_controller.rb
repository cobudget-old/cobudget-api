class DevelopmentController < ApplicationController
  before_action :development_only

  def setup_group
    # refactor into method
    Allocation.destroy_all
    Bucket.destroy_all
    Contribution.destroy_all
    Group.destroy_all
    Membership.destroy_all
    User.destroy_all

    admin = User.create(name: 'Admin', email: 'admin@example.com', password: 'password')
    group = Group.create(name: Faker::Company.name)
    group.add_admin(admin)
    redirect_to "http://localhost:9000/#/groups/#{group.id}"
  end

  private 
    def development_only
      raise 'noooooo' unless Rails.env.development?
    end
end