class Webhooks::Slack::BucketCreated < Webhooks::Slack::Base

  def text
    "*#{eventable.user.name}* created a new idea in *#{view_group_on_cobudget}*"
  end

  def attachment_fallback
    "*#{eventable.name}*\n#{eventable.description}\n"
  end

  def attachment_title
    bucket_link
  end

  def attachment_text
    "#{eventable.description}\n#{bucket_link('Discuss it on Cobudget')}"
  end

  def attachment_fields
    []
  end

end
