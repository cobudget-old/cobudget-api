class GroupSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :rounds, serializer: RoundShortSerializer

  def rounds
    object.rounds.select { |round| round.mode != "pending" || round.is_admin?(current_user) }
  end

end