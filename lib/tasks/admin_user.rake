namespace :admin_user do
	desc "TODO"
	task :set, :password
	task :set => :environment do |task_name, args|
		password = args[:password]
		begin
			if AdminUser.count == 0
				AdminUser.new(password: password).save!
			else
				AdminUser.first.update!(password: password)
			end
		rescue => error
			print "Usage: rake #{task_name}[some password]\n"
			raise error
		end
	end
end
