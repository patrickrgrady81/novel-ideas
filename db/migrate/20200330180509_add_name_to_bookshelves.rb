class AddNameToBookshelves < ActiveRecord::Migration[6.0]
  def change
    add_column :bookshelves, :name, :string
  end
end
