class CreateItemsAndShoppingLists < ActiveRecord::Migration
  def change
  	create_table :items_shopping_lists, :id => false do |t|
  		t.integer :item_id
  		t.integer :shopping_list_id
  	end
  end
end
