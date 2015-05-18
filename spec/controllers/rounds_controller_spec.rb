require 'rails_helper'

RSpec.describe RoundsController, :type => :controller do

  describe "GET /rounds/:id" do
    
    context 'admin' do

      before do
        # make_user_group_admin
        # group.rounds << round
        # login_user with devise
        # get :show, {id: round.id}, request_headers
      end

      xit "returns success if round is pending" do
      end

      xit "returns success if round is not pending" do
      end

    end

    context 'member' do

      xit "returns forbidden if round is pending" do
      end

      xit "returns success if round is not pending" do
      end

    end
  end

end
