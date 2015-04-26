class RoundsController < ApplicationController

  api :GET, '/rounds/:round_id', 'Full details of round'
  def show
    round = Round.find(params[:id])
    if round.group.is_admin?(current_user) || round.mode != "pending"
      respond_with resource
    else
      respond_with user_not_authorized
    end
  end

  api :POST, '/rounds', 'Create a round'
  def create
    create_resource(round_params_create)
  end

  api :PUT, '/rounds/:round_id', 'Update a round'
  def update
    update_resource(round_params_update)
  end

  api :DELETE, '/rounds/:round_id', 'Deletes a round'
  def destroy
    destroy_resource
  end

private
  def round_params_create
    params.require(:round).permit(:name, :group_id, :members_can_propose_buckets)
  end

  def round_params_update
    params.require(:round).permit(:name, :starts_at, :ends_at, :members_can_propose_buckets)
  end
end
