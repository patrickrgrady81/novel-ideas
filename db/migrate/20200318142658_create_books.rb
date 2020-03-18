class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.text :author
      t.text :title
      t.text :description
      t.text :isbn
      t.decimal :price
      t.text :img

      t.timestamps
    end
  end
end
