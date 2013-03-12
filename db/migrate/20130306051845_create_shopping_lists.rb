class CreateShoppingLists < ActiveRecord::Migration
  def change
    create_table :shopping_lists do |t|
      t.integer :user_id
      t.string :name
      t.boolean :temp, :default => false

      t.timestamps
    end
  end
end
