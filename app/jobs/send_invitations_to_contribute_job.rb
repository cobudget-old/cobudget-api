class SendInvitationsToContributeJob < ActiveJob::Base
  queue_as :default

  def perform(inviter, round)
    round.allocations.each do |allocation|
      if allocation.amount > 0
        UserMailer.invite_to_contribute_email(allocation.user, inviter, round).deliver_later
      end
    end
  end
end