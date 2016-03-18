class Webhooks::Slack::BucketFunded < Webhooks::Slack::Base

  def text
   "#{eventable.name} got funded" 
  end

  def attachment_fallback
    "" #{}"*#{eventable.name}*\n#{eventable.description}\n"
  end

  def attachment_title
    "" #proposal_link(eventable)
  end

  def attachment_text
    "" # "#{eventable.description}\n"
  end

  def attachment_fields
    [{
      title: "nothing",
      value: "nothing"
    }] #[motion_vote_field]
  end

end
