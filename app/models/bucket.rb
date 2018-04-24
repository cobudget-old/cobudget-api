class Bucket < ActiveRecord::Base
  after_create :add_account_after_create
  has_many :contributions, -> { order("amount DESC") }, dependent: :destroy
  has_many :comments, dependent: :destroy
  belongs_to :group
  belongs_to :user

  validates :name, presence: true
  validates :description, presence: true
  validates :group_id, presence: true
  validates :user_id, presence: true
  validates :status, presence: true
  validate :target_cannot_be_updated_unless_idea, on: :update

  before_save :set_timestamp_if_status_updated

  scope :with_totals, -> {
    joins("LEFT JOIN (SELECT bucket_id, sum(amount) AS total, count(DISTINCT user_id) AS count_contrib
           FROM contributions
           GROUP BY bucket_id) AS contrib
           ON buckets.id = contrib.bucket_id
           LEFT JOIN (SELECT bucket_id, count(*) as count_comments
           FROM comments
           GROUP BY bucket_id) AS com
           ON buckets.id = com.bucket_id
           JOIN memberships
           ON buckets.user_id = memberships.member_id AND buckets.group_id = memberships.group_id
           JOIN users
           ON buckets.user_id = users.id")
    .select("buckets.*,
             COALESCE(contrib.total,0) AS total_contributions_db,
             COALESCE(count_contrib,0) AS num_of_contributors_db,
             COALESCE(count_comments,0) AS num_of_comments_db,
             (CASE WHEN memberships.archived_at IS NULL THEN users.name ELSE '[removed user]' END) AS author_name_db,
             (CASE WHEN memberships.archived_at IS NULL THEN users.email ELSE '[removed user]' END) AS author_email_db")
  }

  def total_contributions
    has_attribute?(:total_contributions_db) ? total_contributions_db : contributions.sum(:amount)
  end

  def formatted_total_contributions
    Money.new(total_contributions * 100, currency_code).format
  end

  def formatted_target
    Money.new(target * 100, currency_code).format
  end

  def num_of_contributors
    has_attribute?(:num_of_contributors_db) ? num_of_contributors_db : Contribution.where(bucket_id: id).group(:user_id).count.length
  end

  def funded?
    total_contributions == target
  end

  def formatted_percent_funded
    "#{(total_contributions.to_f / target * 100).round}%"
  end

  def formatted_amount_left
    Money.new(amount_left * 100, currency_code).format
  end

  def amount_left
    target - total_contributions
  end

  def num_of_comments
    has_attribute?(:num_of_comments_db) ? num_of_comments_db : comments.length
  end

  def description_as_markdown
    renderer = Redcarpet::Render::HTML.new
    markdown = Redcarpet::Markdown.new(renderer, extensions = {})
    markdown.render(description).html_safe
  end

  def participants(exclude_author: nil, type: nil, subscribed: nil)
    case type
      when :contributors then ids = contributions.pluck(:user_id)
      when :comments then ids = comments.pluck(:user_id)
      else ids = (contributions.pluck(:user_id) + comments.pluck(:user_id)).uniq
    end
    users = User.where(id: ids)
    users = users.where(subscribed_to_participant_activity: true) if subscribed
    users = users.where.not(id: user_id) if exclude_author
    users.all
  end

  def contributors(exclude_author: nil)
    participants(exclude_author: exclude_author, type: :contributors)
  end

  def commenters(exclude_author: nil)
    participants(exclude_author: exclude_author, type: :commenters)
  end

  def author_email
    has_attribute?(:author_email_db) ? author_email_db : get_author_email
  end

  def get_author_email
    membership = user.membership_for(group)
    !membership || membership.archived? ? "[removed user]" : user.email
  end

  def author_name
    has_attribute?(:author_name_db) ? author_name_db : get_author_name
  end

  def get_author_name
    membership = user.membership_for(group)
    !membership || membership.archived? ? "[removed user]" : user.name
  end

  def is_editable_by?(member)
    member.is_admin_for?(group) || user == member
  end

  def archived?
    archived_at.present?
  end

  def is_idea?
    (status == 'draft') && !archived_at.present?
  end

  def is_funding?
    (status == 'live') && !archived_at.present?
  end

  def is_funded?
    (status == 'funded') && !paid_at.present?
  end

  def is_completed?
    (status == 'funded') && paid_at.present?
  end

  def is_cancelled?
    (['draft', 'live', 'refunded'].include? status) && archived_at.present? && !paid_at.present?
  end

  def balance_from_transactions
    AccountService.balance(account_id)
  end

  def transactions_data_ok?
    if is_idea? || is_completed? || is_cancelled?
      balance_from_transactions == 0.00
    elsif is_funding? || is_funded?
      balance_from_transactions == total_contributions
    else
      false
    end
  end

  private
    def set_timestamp_if_status_updated
      if status_changed?
        case self.status
          when "live" then self.live_at = Time.now.utc
          when "funded" then self.funded_at = Time.now.utc
        end
      end
    end

    def currency_code
      group.currency_code
    end

    def target_cannot_be_updated_unless_idea
      if target_changed? && !is_idea?
        errors.add(:target, "target can only be changed for draft buckets")
      end
    end

    def add_account_after_create
      account = Account.new({group_id: group_id})
      if account.save
        self.account_id = account.id
        save
      end
    end
end
