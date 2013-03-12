class Shop < ActiveRecord::Base
  attr_accessible :user_id, :name
  belongs_to :user
  has_many :items
  validate :user_id_exists?


  # Orders are tied to both the seller and buyer
  has_many :sales, :class_name => 'Order'

  def user_id_exists?()
    unless User.find_by_id(user_id)
        errors[:base] << "User does not exist"
    end
  end
end
