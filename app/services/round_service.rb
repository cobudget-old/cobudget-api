class RoundService
  def self.open_for_proposals(round:, admin:)
    if round.save
      SendInvitationsToProposeJob.perform_later(admin, round)
      round_open_job = SendInvitationsToContributeJob.set(wait_until: round.starts_at).perform_later(admin, round)
      round_closed_job = SendRoundClosedNotificationsJob.set(wait_until: round.ends_at).perform_later(admin, round)
      round.update(
        round_open_mailer_job_id: delayed_job_for(round_open_job).id,
        round_closed_mailer_job_id: delayed_job_for(round_closed_job).id
      )
    end
  end

  def self.open_for_contributions(round:, admin:)
    round.starts_at = Time.zone.now
    if round.save
      SendInvitationsToContributeJob.perform_later(admin, round)
      round_closed_job = SendRoundClosedNotificationsJob.set(wait_until: round.ends_at).perform_later(admin, round)
      round.update(round_closed_mailer_job_id: delayed_job_for(round_closed_job).id)
    end
  end

  def self.delayed_job_for(active_job)
    Delayed::Job.all.select { |job| job.handler.include?(active_job.job_id) }.first
  end
end