class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	if !Rails.env.development?
		rescue_from Exception, with: :render_500
		rescue_from ActiveRecord::RecordNotFound, with: :render_404
		rescue_from ActionController::RoutingError, with: :render_404
	end

	def routing_error
		raise ActionController::RoutingError.new(params[:path])
	end

	def render_404(e = nil)
		logger.info "Rendering 404 with exception: #{e.message}" if e
		render template: 'errors/404', status: 404, layout: 'application'
	end

	def render_500(e = nil)
		logger.info "Rendering 500 with exception: #{e.message}" if e
		render template: 'errors/500', status: 500, layout: 'application'
	end
end
