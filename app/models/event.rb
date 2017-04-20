class Event < ActiveRecord::Base
  KINDS = %w[bucket_created bucket_moved_to_funding bucket_funded]

  belongs_to :eventable, polymorphic: true
  belongs_to :group
  belongs_to :user

  scope :chronologically, -> { order('created_at asc') }

  after_create :notify_webhooks!, if: :group

  validates_inclusion_of :kind, :in => KINDS
  validates_presence_of :eventable

  def belongs_to?(this_user)
    self.user_id == this_user.id
  end

  def notify_webhooks!
    self.group.webhooks.each { |webhook| WebhookService.publish! webhook: webhook, event: self }
  end
  handle_asynchronously :notify_webhooks!

end
