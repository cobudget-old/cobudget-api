class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string      :kind, limit: 255
      t.references  :eventable, polymorphic: true, index: true
      t.references  :user, index: true
      t.references  :group, index: true
      t.timestamps
    end
  end
end
