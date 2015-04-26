require 'rails_helper'

RSpec.describe Round, :type => :model do
  it "starts_at and ends_at must both be present or neither be present" do
    expect { Round.create!(name: 'hi', group: group) }.not_to raise_error
    expect { Round.create!(name: 'hi', group: group,
             starts_at: Time.now + 1.day,
             ends_at: Time.now + 3.days) }.not_to raise_error

    expect { Round.create!(name: 'hi', group: group,
             starts_at: Time.now + 1.day) }.to raise_error
    expect { Round.create!(name: 'hi', group: group,
             ends_at: Time.now + 1.day) }.to raise_error
  end

  it 'starts_at must be before ends_at' do
    expect { Round.create!(name: 'hi', group: group,
             starts_at: Time.now + 2.days,
             ends_at: Time.now + 1.day) }.to raise_error
  end

  context "#mode" do
    it "upon creation, pending mode" do
      expect(FactoryGirl.create(:pending_round).mode).to eq("pending")
    end
    it "if starts_at set but not reached, proposal mode" do
      expect(FactoryGirl.create(:round_open_for_proposals).mode).to eq("proposal")
    end
    it "if current time in between starts_at and ends_at, contribution mode" do
      expect(FactoryGirl.create(:round_open_for_contributions).mode).to eq("contribution")
    end
    it "if current time after ends_at, then closed mode" do
      expect(FactoryGirl.create(:round_closed).mode).to eq("closed")
    end
  end

end
