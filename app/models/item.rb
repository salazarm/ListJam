class Item < ActiveRecord::Base
  attr_accessible :name, :price, :shop_id, :ordered, :order_id
 
  validates_presence_of :name, :price, :shop_id
  belongs_to :shop
  belongs_to :order
  has_and_belongs_to_many :shopping_lists

  # Clones an item so that we know what it looked like at this point in time
  def get_clone()
  	return Item.create(:name =>name, :price=>price, 
  		:shop_id=>shop_id)
  end

end
