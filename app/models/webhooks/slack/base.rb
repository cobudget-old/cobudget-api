Webhooks::Slack::Base = Struct.new(:event) do

  def username
    "Cobudget Bot"
  end

  def icon_url
    ENV["SLACK_ICON_URL"]
  end

  def text
    ""
  end

  def attachments
    [{
      title:       attachment_title,
      color:       '#00B8D4',
      text:        attachment_text,
      fields:      attachment_fields,
      fallback:    attachment_fallback
    }]
  end

  alias :read_attribute_for_serialization :send

  private

  def view_group_on_cobudget(text = nil)
    "<#{url_root}groups/#{eventable.group.id}|#{text || eventable.group.name}>"
  end

  def bucket_link(text = nil)
    "<#{url_root}buckets/#{eventable.id}|#{text || eventable.name}>"
  end

  def url_root
    ENV["ROOT_URL"] + "/#/"
  end

  def eventable
    @eventable ||= event.eventable
  end

  def author
    @author ||= eventable.author
  end

end

