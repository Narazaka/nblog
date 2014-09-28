module ApplicationHelper
	@@markdown = Redcarpet::Markdown.new Redcarpet::Render::HTML, Settings.markdown.to_hash

	def markdown(text)
		@@markdown.render(text).html_safe
	end

	def admin_session
		session[:admin] and session[:admin] > Time.now
	end
end
