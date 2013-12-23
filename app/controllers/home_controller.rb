class HomeController < ApplicationController

	def index
		@pic = current_user.facebook.get_picture("me")
	end

end
