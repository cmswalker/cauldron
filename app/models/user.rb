class User < ActiveRecord::Base

	has_secure_password

	has_many :charts

	validates :username, uniqueness: true, presence: true
	validates :email, uniqueness: true, presence: true
	validates :password, confirmation: true
	validates :password_confirmation, presence: true
	# validates :api_key, uniqueness: true

	def self.confirm(params)
		@user = User.find_by({username: params[:username]})
		@user.try(:authenticate, params[:password])
	end

end
