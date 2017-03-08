class GroupSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id,
             :name,
             :balance,
             :currency_symbol,
             :currency_code,
             :is_launched,
             :plan,
             :trial_end, 
             :waiting_for_payment,
             :total_in_circulation,
             :total_in_funded,
             :total_allocations,
             :total_contributions
end
