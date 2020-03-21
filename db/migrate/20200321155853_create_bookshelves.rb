class CreateBookshelves < ActiveRecord::Migration[6.0]
  def change
    create_table :bookshelves do |t|
      t.references :user, null: true, foreign_key: { on_delete: :cascade }
      t.references :book, null: true, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
