class BucketService
  def self.bucket_created(bucket: ,current_user: )
    Events::BucketCreated.publish!(bucket, current_user)
  end

  def self.bucket_moved_to_funding(bucket: , current_user: )
    Events::BucketMovedToFunding.publish!(bucket, current_user)
  end

  def self.bucket_received_contribution(bucket: , current_user: )
    if bucket.funded?
      Events::BucketFunded.publish!(bucket, current_user)
    end
  end

  def self.archive(bucket:, exclude_author_from_email_notifications: false)
    bucket.update(archived_at: DateTime.now.utc)
    if bucket.status == 'live'
      bucket.contributors(exclude_author: exclude_author_from_email_notifications).each do |funder|
        UserMailer.notify_funder_that_bucket_was_archived(funder: funder, bucket: bucket).deliver_now
      end
      bucket.contributions.destroy_all
    end
  end
end
