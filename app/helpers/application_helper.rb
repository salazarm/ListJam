module ApplicationHelper
	
	# Chjecks if a user can modify an item.
	def can_modify_item?(user, item)
		return get_owner_of_item(item).id == user.id
	end

	# Check if a user can modify a list.
	def can_modify_list?(user, list)
		return user.id == list.user_id
	end

	# Gets the owner of an item.
	def get_owner_of_item(item)
		return get_owner_of_shop(Shop.find_by_id(item.shop_id))
	end

	# Gets the owner of a shop.
	def get_owner_of_shop(shop)
		return User.find_by_id(shop.user_id)
	end

	# Checks if a list is the active list of a user.
	def is_active_list?(user, list)
		return user.active_list_id == list.id
	end

	# Gets the active list of a user.
	def active_list(user)
		return ShoppingList.find_by_id(user.active_list_id)
	end

	# Checks if a user is a temporary user.
	def is_temp_user?(user)
		return user.temp
	end
end
