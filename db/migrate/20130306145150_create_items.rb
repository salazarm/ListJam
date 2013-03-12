class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :shop_id
      t.boolean :ordered, :default => false
      t.integer :order_id
      t.string :name
      t.decimal :price, :scale => 2

      t.timestamps
    end
  end
end
