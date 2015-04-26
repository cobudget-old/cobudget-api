require 'rails_helper'

RSpec.describe Group, :type => :model do

  let!(:user) { FactoryGirl.create(:user) }
  let!(:group) { FactoryGirl.create(:group) }

  context "#add_admin(user)" do
    it "creates an admin membership between the group and the user" do
      group.add_admin(user)
      expect(Membership.find_by(member_id: user.id, group_id: group.id, is_admin: true)).to be_truthy
    end
  end

  context "#is_admin?(user)" do
    it "returns true if user is admin of the group" do
      group.add_admin(user)
      expect(group.is_admin?(user)).to be_truthy
    end

    it "returns false if user is not admin of the group" do
      expect(group.is_admin?(user)).to be_falsey
    end
  end

end
