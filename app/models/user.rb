class User < ActiveRecord::Base
  # Keeping tracking of active_list_id so that I don't have to keep track
  # of whether a shopping list is "active" and so that I don't have to query
  # all of a user's shopping_lists to find the one that has "active=true"

  VALID_EMAIL_REGEX = /^.+@.+\..+$/i 
  attr_accessible :active_list_id, :password, :password_confirmation, :email, :temp
  attr_accessor :password, :password_confirmation

  before_create { generate_token(:auth_token) }
  # Initialize a cart

  before_validation :downcase_email

  validates_presence_of :email, :password, :password_confirmation, 
                          :on => :create, :unless => "temp"
   
  validates :password, :length => (6..32), :confirmation => true, :if => :setting_password?

    #something@something.something
  validates :email, :uniqueness => true, 
              :format => {:with => VALID_EMAIL_REGEX },
              :unless => "temp"

  # Create the user's shopping cart!
  after_create { make_list(:name => email ? email+"'s shopping list" : "Anonymous' shopping list") }

  has_many :shopping_lists
  has_many :shops
  has_many :transactions, :class_name => 'Order'

  HUMANIZED_ATTRIBUTES = {
    :password_digest => "Password"
  }

# Setter method for password. Sets up the passowrd_salt and password_digest for future verification.
 def password=(password_str)
    @password = password_str
    write_attribute(:password_salt,BCrypt::Engine.generate_salt)
    write_attribute(:password_digest,BCrypt::Engine.hash_secret(password_str, password_salt))
  end

  # Used to tell if we need to validate the password
  def setting_password?
    self.password || self.password_confirmation
  end
 
  # Checks if the user provided the correct password
  def authenticate(password)
    password.present? && password_digest.present? && password_digest == BCrypt::Engine.hash_secret(password, password_salt)
  end

  # Creates a "default" list
  def factory_list
    make_list(:name=>"Anon's List")
  end

  # Makes a cart and sets that cart to be the currently active cart
  def make_list(params)
  	active_list = self.shopping_lists.new(params)
    active_list.temp = temp
    save
  	return set_active_list(active_list)
  end

  # Finds all order transactions
  def get_orders
    return Order.where("buyer_id" => id)
  end

  # Finds all sales transactions
  def get_sales
    return Order.where("seller_id" => id)
  end

  # Transfers list from temp_user to the current user.
  # Called at login.
  def transfer_list_over(temp_user)
    temp_list = ShoppingList.find_by_id(temp_user.active_list_id)
    if !temp_list.items.empty?
      temp_list.user_id = self.id
      temp_list.temp = false
      temp_list.save
      self.active_list_id = temp_list.id
    else
      temp_list.destroy
    end
    return save
  end

  # Returns the active list
  def get_active_list()
    return ShoppingList.find_by_id(active_list_id)
  end

  # Adds an item to the currently active list
  def add_to_list(item)
    return get_active_list().items << item
  end

  # Sets the currently active_list_id
  def set_active_list(list)
    self.active_list_id = list.id
    return save
  end

  # Changes the password
  def change_password_digest(digest)
  	return update_attribute(:password_digest, digest)
  end

  # Authorization token for validating user
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column]) 
  end

  # Overrides humanized attribute names
  def self.human_attribute_name(attr, options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  # Downcase email because emails are usually not case sensitive
  def downcase_email
    self.email = self.email.downcase if self.email.present?
  end

end
