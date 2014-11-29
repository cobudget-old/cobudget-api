class AllocationSerializer < ActiveModel::Serializer
  attributes :id, :amount_cents, :round_id
  has_one :user
end
