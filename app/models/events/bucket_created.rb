class Events::BucketCreated < Event

  def self.publish!(bucket, user)
    create!(kind: 'bucket_created',
            eventable: bucket,
            group: bucket.group,
            user: user)
  end

end
