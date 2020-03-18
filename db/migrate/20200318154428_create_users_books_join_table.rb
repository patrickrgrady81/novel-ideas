class CreateUsersBooksJoinTable < ActiveRecord::Migration[6.0]
  def change
    create_join_table :users, :books do |t|
      t.references :user_id, null: true, foreign_key: true
      t.references :book_id, null: true, foreign_key: true
    end
  end
end
