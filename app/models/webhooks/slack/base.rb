Webhooks::Slack::Base = Struct.new(:event) do
  include Routing

  def username
    "Cobudget Bot"
  end

  def icon_url
    "https://pbs.twimg.com/profile_images/535182261553876992/MV2TWTgd.png"
  end

  def text
    ""
  end

  def attachments
    [{
      title:       attachment_title,
      text:        attachment_text,
      fields:      attachment_fields,
      fallback:    attachment_fallback
    }]
  end

  alias :read_attribute_for_serialization :send

  private

  def view_group_on_cobudget(text = nil)
    "<#{group_url(eventable.group)}|#{text || eventable.group.name}>"
  end

  def eventable
    @eventable ||= event.eventable
  end

  def author
    @author ||= eventable.author
  end

end

