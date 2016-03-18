class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string      :kind, limit: 255
      t.references  :eventable, polymorphic: true, index: true
      t.references  :user, index: true
      t.references  :group, index: true
      t.integer     :sequence_id, index: true, default: nil, null: true
      t.timestamps
    end
    add_index :events, [:group_id, :sequence_id], unique: true
  end
end
