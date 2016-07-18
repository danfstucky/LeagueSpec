class User < ActiveRecord::Base
	
 #friendship associations
  has_many :friendships, :class_name => "Friendship", :foreign_key => "user_id", :dependent => :destroy
  has_many :friends, :through => :friendships
  has_many :accepted_friendships, -> { where('friendship_status_id = ?', 2) }, :class_name => "Friendship"
  has_many :pending_friendships, -> { where('initiator = ? AND friendship_status_id = ?', false, 1) }, :class_name => "Friendship"
  has_many :friendships_initiated_by_me, -> { where('initiator = ?', true) }, :class_name => "Friendship", :foreign_key => "user_id", :dependent => :destroy
  has_many :friendships_not_initiated_by_me, -> { where('initiator = ?', false) }, :class_name => "Friendship", :foreign_key => "user_id", :dependent => :destroy
  has_many :occurences_as_friend, :class_name => "Friendship", :foreign_key => "friend_id", :dependent => :destroy
	attr_accessor :remember_token, :activation_token, :reset_token
	before_save :downcase_email
	before_create :create_activation_digest

	validates :name,	presence: true, length: { maximum: 30 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255 },
						format: { with: VALID_EMAIL_REGEX },
						uniqueness: { case_sensitive: false }

	has_secure_password
	validates :password, length: { minimum: 6 }
	# add in api cross reference later to verify summoner name exists in lol db

	# Returns the hash digest of the given string.

	def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end

	# Returns a random token.
	def User.new_token
		SecureRandom.urlsafe_base64
	end

	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end

	# Returns true if the given token matches the digest.
	def authenticated?(attribute, token)
		digest = send("#{attribute}_digest")
		return false if digest.nil?
		#return false if remember_digest.nil?
		BCrypt::Password.new(digest).is_password?(token)
	end

	# Forgets a user.
	def forget
		update_attribute(:remember_digest, nil)
	end

	# Activates an account
	def activate
		update_attribute(:activated, true)
		update_attribute(:activated_at, Time.zone.now)
	end

	# Sends an activation email
	def send_activation_email
		UserMailer.account_activation(self).deliver_now
	end
	
	# Sets the password reset attributes
	def create_reset_digest
		self.reset_token = User.new_token
		update_attribute(:reset_digest, User.digest(reset_token))
		update_attribute(:reset_sent_at, Time.zone.now)
	end

	# Sends password reset email.
	def send_password_reset_email
		UserMailer.password_reset(self).deliver_now
	end

	# Returns true if a password reset has expired
	def password_reset_expired?
		reset_sent_at < 2.hours.ago
	end
	
  def self.find_summoner_by_name(summoner_name)
		where(name: summoner_name).first
	end

	def has_reached_daily_friend_request_limit?
    friendships_initiated_by_me.where('created_at > ?', Time.now.beginning_of_day).count >= Friendship.daily_request_limit
  end

	private

	#Converts email to all lower-case
	def downcase_email
		self.email = email.downcase
	end

	# Creates and assigns the activation token and digest
	def create_activation_digest
		self.activation_token = User.new_token
		self.activation_digest = User.digest(activation_token)
	end

	def can_request_friendship_with(user)
    !self.eql?(user) && !self.friendship_exists_with?(user)
  end

  def friendship_exists_with?(friend)
    Friendship.where("user_id = ? AND friend_id = ?", self.id, friend.id).first
  end

  
end
