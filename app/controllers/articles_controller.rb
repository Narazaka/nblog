class ArticlesController < ApplicationController
	before_action :set_all_tags, only: [:new, :edit, :tags]
	before_action :set_article, only: [:article, :edit, :update, :destroy, :comment_create]
	before_action :set_comment, only: [:comment_update_admin, :comment_destroy, :comment_destroy_admin]
	before_action :authenticate, only: [:new, :edit, :create, :update, :destroy, :comment_update_admin, :comment_destroy_admin]
	before_action :authenticate_comment, only: [:comment_destroy]
	before_action :set_articles, only: [:articles, :list, :dates]
	def article
		@title = @article.title.empty? ? I18n.t('empty_title') : @article.title
		@comment = @article.comments.new
	end
	def articles
		@articles = @articles.page(params[:page]).per(Settings.articles_per_page)
		if not @title
			@title = ''
		end
		if ((not params[:page] or params[:page].empty?) ? 0 : params[:page].to_i) > 1
			@title += ' (' + params[:page] + ')'
		end
	end
	def list
		@articles = @articles.page(params[:page]).per(Settings.list_per_page)
		if not @title
			@title = I18n.t('title.list')
		end
		if ((not params[:page] or params[:page].empty?) ? 0 : params[:page].to_i) > 1
			@title += ' (' + params[:page] + ')'
		end
	end
	def tags
		@title = I18n.t('title.tags')
	end
	def dates
		@title = I18n.t('title.dates')
	end
	def new
		@title = I18n.t('title.new')
		@article = Article.new
	end
	def edit
		@title = I18n.t('title.edit')
	end
	def create
		@article = Article.new(article_params)
		begin
			if @article.contents.empty?
				raise I18n.t('error.contents_empty')
			end
			@article.save!
			flash.notice = I18n.t('notice.create')
			redirect_to :action => :article, :id => @article.id
		rescue => error
			flash[:alert] = error
			set_all_tags
			@title = I18n.t('title.new')
			render :new
		end
	end
	def update
		begin
			if @article.contents.empty?
				raise I18n.t('error.contents_empty')
			end
			@article.update!(article_params)
			flash.notice = I18n.t('notice.update')
			redirect_to :action => :article, :id => @article.id
		rescue => error
			flash[:alert] = error
			set_all_tags
			@title = I18n.t 'title.edit'
			render :edit
		end
	end
	def destroy
		begin
			@article.destroy!
			flash.notice = I18n.t('notice.destroy')
			redirect_to :action => :articles
		rescue => error
			flash[:alert] = error
			render :action => :article, :id => @article.id
		end
	end
	def comment_create
		@comment = @article.comments.new(comment_params)
		if Settings.auto_allow_show_comments
			@comment.allow_show = true
		end
		begin
			if @comment.contents.empty?
				raise I18n.t('error.contents_empty')
			end
			@comment.save!
			flash.notice = I18n.t('notice.comment_create')
			redirect_to :action => :article, :id => @article.id
		rescue => error
			flash[:alert] = error
			render :action => :article, :id => @article.id
		end
	end
	def comment_update_admin
		begin
			@comment.update!(comment_params_admin)
			flash.notice = I18n.t('notice.comment_update_admin')
			redirect_to :action => :article, :id => @article.id
		rescue => error
			flash[:alert] = error
			render :action => :article, :id => @article.id
		end
	end
	def comment_destroy
		begin
			@comment.destroy!
			flash.notice = I18n.t('notice.comment_destroy')
			redirect_to :action => :article, :id => @article.id
		rescue => error
			flash[:alert] = error
			render :action => :article, :id => @article.id
		end
	end
	def comment_destroy_admin
		begin
			@comment.destroy!
			flash.notice = I18n.t('notice.comment_destroy_admin')
			redirect_to :action => :article, :id => @article.id
		rescue => error
			flash[:alert] = error
			render :action => :article, :id => @article.id
		end
	end
	private
	def admin_session
		session[:admin] and session[:admin] > Time.now
	end
	private
	def authenticate
		if not admin_session
			flash.alert = I18n.t('error.not_authenticated')
			redirect_to :action => :articles
		end
	end
	private
	def authenticate_comment
		if not @comment.authenticate(params[:comment][:password])
			flash.alert = I18n.t('error.wrong_password')
			redirect_to :action => :article, :id => @article.id
		end
	end
	private
	def set_all_tags
		articles = articles_display_limit(Article)
		@tags = articles.tag_counts_on(:tags)
	end
	private
	def article_params
		params.require(:article).permit(:title, :created_at_display, :updated_at_display, :hide_at_display, :contents, :tag_list)
	end
	private
	def comment_params
		params.require(:comment).permit(:title, :name, :url, :mail, :for_only_master, :contents, :password)
	end
	private
	def comment_params_admin
		params.require(:comment).permit(:allow_show)
	end
	private
	def set_comment
		set_article
		@comment = @article.comments.find(params[:cid])
	end
	private
	def set_article
		begin
			article = Article.find(params[:id])
			if not admin_session
				now = DateTime.now
				if (article.created_at_display and article.created_at_display > now) or (article.hide_at_display and article.hide_at_display < now)
					raise ActiveRecord::RecordNotFound
				end
			end
			@article = article
		rescue => error
			raise error
			flash.alert = error
			redirect_to :not_found
		end
	end
	private
	def set_articles
		articles = Article.all
		title = []
		if params[:tag]
			tags = params[:tag].split(/,\s*/)
			articles = articles.tagged_with(tags)
			title.push I18n.t('label.tag') + ' [' + tags.join(', ') + ']'
		end
		begin
			if params[:date]
				year, month, day, hour, minute, second = params[:date].split('-')
			end
			if year
				title_date = [year + I18n.t('datetime.prompts.year')]
				if month
					title_date.push month + I18n.t('datetime.prompts.month')
					if day
						title_date.push day + I18n.t('datetime.prompts.day')
						if hour
							title_date.push hour + I18n.t('datetime.prompts.hour')
							if minute
								title_date.push minute + I18n.t('datetime.prompts.minute')
								if second
									title_date.push second + I18n.t('datetime.prompts.second')
									period_begin = DateTime.new(Integer(year), Integer(month), Integer(day), Integer(hour), Integer(minute), Integer(second))
									period_end = period_begin + 1.second
								else
									period_begin = DateTime.new(Integer(year), Integer(month), Integer(day), Integer(hour), Integer(minute))
									period_end = period_begin + 1.minute
								end
							else
								period_begin = DateTime.new(Integer(year), Integer(month), Integer(day), Integer(hour))
								period_end = period_begin + 1.hour
							end
						else
							period_begin = DateTime.new(Integer(year), Integer(month), Integer(day))
							period_end = period_begin.tomorrow
						end
					else
						period_begin = DateTime.new(Integer(year), Integer(month))
						period_end = period_begin.next_month
					end
				else
					period_begin = DateTime.new(Integer(year))
					period_end = period_begin.next_year
				end
				articles = articles.where('case when updated_at_display is not ? then (updated_at_display >= ? and updated_at_display < ?) else (updated_at >= ? and updated_at < ?) end', nil, period_begin, period_end, period_begin, period_end)
				title.push I18n.t('label.date') + ' [' + title_date.join('') + ']'
			end
		rescue
			flash[:alert] = I18n.t 'error.date'
		end
		articles = articles_display_limit(articles)
		@articles = articles.order('(case when updated_at_display is not ? then updated_at_display else updated_at end) desc')
		if not title.empty?
			@title = title.join ' / '
		end
	end
	private
	def articles_display_limit(articles)
		if admin_session
			articles
		else
			now = DateTime.now
			articles.where('(case when created_at_display is not ? then created_at_display <= ? else 1 = 1 end) and (case when hide_at_display is not ? then hide_at_display >= ? else 1 = 1 end)', nil, now, nil, now)
		end
	end
end
