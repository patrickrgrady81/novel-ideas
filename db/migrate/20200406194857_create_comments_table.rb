class CreateCommentsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :comments_tables do |t|
      t.references :user_id, null: false, foreign_key: true
      t.references :post_id, null: false, foreign_key: true
      t.string :title
      t.text :content
    end
  end
end
