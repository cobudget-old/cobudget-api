class Events::BucketFunded < Event

  def self.publish!(bucket, user)
    create!(kind: 'bucket_funded',
            eventable: bucket,
            group: bucket.group,
            user: user)
  end

end

