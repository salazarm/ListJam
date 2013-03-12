class Order < ActiveRecord::Base
	attr_accessible :seller, :buyer, :items, :created_at
  belongs_to :seller, :class_name => "User", :foreign_key => "seller_id"
  belongs_to :buyer, :class_name => "User", :foreign_key => 'buyer_id'
  has_one :item
  validates_presence_of :buyer, :seller

  def self.create_orders_from_list(buyer, list)
    errors = ""
  	list.items.each do |item1|
      order = Order.new
      clone = item1.get_clone()
  		clone.order_id = order.id
      clone.ordered = true
      clone.save

      order.seller_id = Shop.find_by_id(item1.shop_id).user_id
      order.buyer_id = buyer.id
      order.item = clone
      if !order.save
        errors << "Could not order item "+item.name+"\n"
      end
      if !errors[0]
        # No errors. The buy gets a new list now.
        buyer.factory_list
      end
  	end
  end
end
