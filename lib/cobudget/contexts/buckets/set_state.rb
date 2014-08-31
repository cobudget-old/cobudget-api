require 'playhouse/context'
require 'cobudget/entities/bucket'
require 'cobudget/entities/account'
require 'cobudget/roles/entry_collection'

module Cobudget
  module Buckets
    class SetState < Playhouse::Context
      class NotAuthorizedToUpdateBucket < Exception; end
      actor :bucket, repository: Bucket, role: EntryCollection
      actor :current_user, repository: User
      actor :state

      def perform
        raise NotAuthorizedToChange unless current_user.can_manage_budget?(bucket.budget)
        if state == "funded"
          bucket.set_funded!
          bucket.as_json
          Pusher.trigger('cobudget', 'bucket_updated', {bucket: bucket.as_json})
        end
        if state == "cancelled"
          refund
          bucket.set_cancelled!
          bucket.as_json
          Pusher.trigger('cobudget', 'bucket_updated', {bucket: bucket.as_json})
        end
      end

      def refund
        bucket.budget.accounts.each_with_index do |a, i|
          #if isnt the budget account
          if a.user_id
            #balance give cents, transfer expects dollars
            amount = bucket.balance_from_user(a.user, a.budget_id) / 100.00
            if amount > 0
              transfer = TransferMoney.new(source_account: bucket, destination_account: a, amount: amount, creator: current_user)
              transfer.call
            end
          end
        end
      end
    end
  end
end
