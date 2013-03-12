module SessionsHelper
	def get_or_create_cart
		unless session[:shopping_list_id]
			session[:shopping_list_id] = Shopping_list.create()
		end
	end
end
