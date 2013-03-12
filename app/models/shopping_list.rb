class ShoppingList < ActiveRecord::Base
  attr_accessible :name, :user_id, :temp
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

  def add_item(item)
    self.items.create(:item_id => item.id)
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

end
