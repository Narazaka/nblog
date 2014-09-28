class Comment < ActiveRecord::Base
	belongs_to :article
	has_secure_password
end
