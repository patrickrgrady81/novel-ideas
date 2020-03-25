class CreateFriends < ActiveRecord::Migration[6.0]
  def change
    create_table :friends do |t|
      t.integer :user1, null: false
      t.integer :user2, null: false
      t.boolean :accepted, default: false

      t.timestamps
    end
  end
end
