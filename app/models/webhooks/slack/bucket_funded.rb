class Webhooks::Slack::BucketFunded < Webhooks::Slack::Base

  def text
   "#{eventable.group.currency_symbol}*#{eventable.target}* #{eventable.group.currency_code} bucket just got fully funded!" 
  end

  def attachment_fallback
    "*#{eventable.name}*\n#{eventable.description}\n"
  end

  def attachment_title
    bucket_link
  end

  def attachment_text
    "#{eventable.description}\n#{bucket_link('View it on Cobudget')}"
  end

  def attachment_fields
    []
  end

end
