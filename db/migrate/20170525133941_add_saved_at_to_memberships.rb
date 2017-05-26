class AddSavedAtToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :saved_at, :datetime
  end
end
