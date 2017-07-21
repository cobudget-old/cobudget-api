class AddDetailsToMemberships < ActiveRecord::Migration
  def change
    change_table :memberships do |t|
      t.rename :saved_at, :saved_funds_at
    end
  end
end
