class Webhooks::Slack::BucketMovedToFunding < Webhooks::Slack::Base

  def text
    "Bucket with #{eventable.group.currency_symbol}#{eventable.target} #{eventable.group.currency_code} target is now open for funding"  
  end

  def attachment_fallback
    "*#{eventable.name}*\n#{eventable.description}\n"
  end

  def attachment_title
    bucket_link
  end

  def attachment_text
    "#{eventable.description}\n#{bucket_link('Comment or Fund it on Cobudget')}"
  end

  def attachment_fields
    []
  end

end
