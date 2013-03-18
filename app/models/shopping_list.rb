class ShoppingList < ActiveRecord::Base
  attr_accessible :name, :user_id, :temp, :public
  has_and_belongs_to_many :items
  belongs_to :user

  validates_presence_of :name, :user_id

  validates :name, :length => { :minimum => 3 }

  def get_total_price
  	return self.items.to_a.sum(&:price)
  end

  def get_item_count
  	return self.items.length
  end

  # Creates a deep copy of the shopping list items as an array
  # This is used for creating an order with this list
  def clone_list_to_array
    clone = Array.new
    self.items.each do |item| 
      result.push(item.get_clone())
    end
    return clone
  end
  
  # To remove the item it counts how many of that items 
  # existed before. It is done this way because of a limitation
  # on delete. In the future this should be changed by moving shopping
  # list items to a subclass of item that has a count indicating how 
  # many of said item are in the cart.
  def remove_item(user, item)
    before = get_item_count
    self.items.delete(item)
    after = get_item_count
    (before-after-1).times do
      user.add_to_list(item)
    end
  end

end
