require 'rails_helper'

RSpec.describe Round, :type => :model do
  describe "#mode" do
    it "if unpublished -- draft mode" do
      expect(create(:draft_round).mode).to eq("draft")
    end

    it "if published, and starts_at set but not reached -- proposal mode" do
      expect(create(:round_open_for_proposals).mode).to eq("proposal")
    end

    it "if published, and current time is between starts_at and ends_at -- contribution mode" do
      expect(create(:round_open_for_contributions).mode).to eq("contribution")
    end
    
    it "if published, and current time is after ends_at -- closed mode" do
      expect(create(:round_closed).mode).to eq("closed")
    end
  end

  describe "#published?" do
    it "returns true if starts_at and ends_at are both present" do
      expect(create(:round_open_for_proposals).published?).to eq(true)
    end

    it "returns false otherwise" do
      expect(create(:draft_round).published?).to eq(false)
    end
  end

  describe "has_valid_duration?" do
    it "returns true if starts_at and ends_at are present, and starts_at is before ends_at" do
      expect(create(:round_open_for_proposals).has_valid_duration?).to eq(true)
    end

    it "otherwise, returns false" do
      expect(create(:draft_round).has_valid_duration?).to eq(false)
    end
  end

  describe "#start_and_end_go_together" do
    it "validates that both starts_at and ends_at to be present or neither be present" do
      expect { Round.create!(name: 'hi', group: group) }.not_to raise_error
      expect { Round.create!(name: 'hi', group: group, starts_at: Time.now + 1.day, ends_at: Time.now + 3.days) }.not_to raise_error
      expect { Round.create!(name: 'hi', group: group, starts_at: Time.now + 1.day) }.to raise_error 
      expect { Round.create!(name: 'hi', group: group, ends_at: Time.now + 1.day) }.to raise_error
    end
  end

  describe "#starts_at_before_ends_at" do
    it 'validates that starts_at is before ends_at' do
      expect { Round.create!(name: 'hi', group: group, starts_at: Time.now + 2.days, ends_at: Time.now + 1.day) }.to raise_error
    end    
  end

  describe "#has_valid_duration_validator" do
    it "checks that a round has a valid_duration" do
      round = build(:round_open_for_proposals)
      expect(round.valid?).to eq(true)
    end

    it "adds an error if round duration not valid" do
      round = build(:draft_round)
      round.assign_attributes(starts_at: Time.zone.now, ends_at: Time.zone.now - 1.days)
      expect(round.valid?).to eq(false)
    end
  end

  xdescribe "#reschedule_mailers_if_necessary" do

    before do
      Delayed::Worker.delay_jobs = true
    end

    context "if starts_at and/or ends_at changed" do
      it "updates round's 'round open' job to run_at the new starts_at time" do
        class FakeJob < ActiveJob::Base
          queue_as :default

          def perform
            puts "i am a fake job"
          end
        end

        initial_starts_at = Time.zone.now + 1.days
        initial_ends_at = Time.zone.now + 2.days
        round = FactoryGirl.create(:round, starts_at: initial_starts_at, ends_at: initial_ends_at)

        round_open_job = FakeJob.set(wait_until: initial_starts_at).perform_later
        delayed_round_open_job = RoundService.delayed_job_for(round_open_job)

        round_closed_job = FakeJob.set(wait_until: initial_ends_at).perform_later
        delayed_round_closed_job = RoundService.delayed_job_for(round_closed_job)

        round.update(round_open_mailer_job_id: delayed_round_open_job.id, round_closed_mailer_job_id: delayed_round_closed_job.id)

        new_starts_at = initial_starts_at + 2.hours
        new_ends_at = initial_ends_at + 2.hours

        round.update(starts_at: new_starts_at, ends_at: new_ends_at)

        delayed_round_open_job.reload
        delayed_round_closed_job.reload

        p "round open job rescheduled: #{delayed_round_open_job.run_at == new_starts_at}"
        p "round closed job rescheduled: #{delayed_round_closed_job.run_at == new_ends_at}"
        # expect(delayed_round_open_job.run_at).to eq(new_starts_at)
        # expect(delayed_round_closed_job.run_at).to eq(new_ends_at)
      end
    end

    context "if neither starts_at or ends_at are changed" do
      it "jobs are not rescheduled" do
      end
    end
  end




























end