class PagesController < ApplicationController
	def signin 
		redirect_to(root_path) if current_user.present?
	end
end
