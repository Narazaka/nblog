Rails.application.routes.draw do
	root :controller => :articles, :action => :articles
	get 'list', :controller => :articles, :action => :list
	get 'tags', :controller => :articles, :action => :tags
	get 'dates', :controller => :articles, :action => :dates
	# mod
	get 'new', :controller => :articles, :action => :new
	post '', :controller => :articles, :action => :create
	scope :article do
		scope ':id' do
			get '', :controller => :articles, :action => :article
			get 'edit', :controller => :articles, :action => :edit
			patch '', :controller => :articles, :action => :update
			delete '', :controller => :articles, :action => :destroy
			scope :comments do
				post '', :controller => :articles, :action => :comment_create
				patch ':cid/admin', :controller => :articles, :action => :comment_update_admin
				delete ':cid', :controller => :articles, :action => :comment_destroy
				delete ':cid/admin', :controller => :articles, :action => :comment_destroy_admin
			end
		end
	end
	namespace :admin_session do
		get 'login', :action => :new
		post 'login', :action => :create
		get 'logout', :action => :destroy
	end
	get  '*not_found' => 'application#routing_error'
	post  '*not_found' => 'application#routing_error'
end
