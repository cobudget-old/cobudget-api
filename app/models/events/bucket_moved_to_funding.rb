class Events::BucketMovedToFunding < Event

  def self.publish!(bucket, user)
    create!(kind: 'bucket_moved_to_funding',
            eventable: bucket,
            group: bucket.group,
            user: user)
  end

end

