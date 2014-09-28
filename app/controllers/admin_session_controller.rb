class AdminSessionController < ApplicationController
	def new
		@title = I18n.t('title.login')
	end
	def create
		admin_user = AdminUser.first
		if admin_user and admin_user.authenticate(params[:password])
			session[:admin] = 1.hour.from_now
			redirect_to root_path
		else
			flash.alert = I18n.t('error.wrong_password')
			@title = I18n.t('title.login')
			render :new
		end
	end
	def destroy
		session[:admin] = nil
		redirect_to root_path
	end
end
