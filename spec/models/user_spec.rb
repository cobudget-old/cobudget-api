require 'rails_helper'

RSpec.describe User, :type => :model do
  let(:user) { create(:user) }
  let(:membership) { create(:membership, member: user) }
  let(:admin_membership) { create(:membership, member: user, is_admin: true) }

  describe "fields" do
	  it { should have_db_column(:email).with_options(default: "", null: false) }
	  it { should have_db_column(:encrypted_password).with_options(default: "", null: false) }
	  it { should have_db_column(:access_token) }
	  it { should have_db_column(:name) }
	  it { should have_db_column(:initialized).of_type(:boolean).with_options(default: false, null: false) }
  end

  describe "associations" do
		it { should have_many(:allocations) }
  end

  describe "validations" do
		it { should validate_presence_of(:name) }
  end

	describe "#name_and_email" do
		it "returns formatted name and email, formatted for email" do
			expect(user.name_and_email).to eq("#{user.name} <#{user.email}>")
		end
	end

	describe "#is_admin_for?(group)" do
		it "returns false if user isn't admin of group" do
		  expect(user.is_admin_for?(membership.group)).to eq false
		end
		
		it "returns true if user is admin of group" do
		  expect(user.is_admin_for?(admin_membership.group)).to eq true
		end
	end

  describe "#destroy" do
    it "when a user is destroyed, so are all of their memberships" do
      user = create(:user)
      group1 = create(:group)
      group2 = create(:group)
      group3 = create(:group)
      membership1 = create(:membership, group: group1, member: user)
      membership2 = create(:membership, group: group2, member: user)
      membership3 = create(:membership, group: group3, member: user)
      user.destroy

      expect(Membership.find_by_id(membership1.id)).to be_nil
      expect(Membership.find_by_id(membership2.id)).to be_nil
      expect(Membership.find_by_id(membership3.id)).to be_nil
    end
  end

end
