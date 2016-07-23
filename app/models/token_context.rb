module TokenContext
# Creates new token
  def new_token
		SecureRandom.urlsafe_base64
  end

  # Returns true if the given token matches the digest.
	def authenticated?(attribute, token)
		digest = send("#{attribute}_digest")
		return false if digest.nil?
		#return false if remember_digest.nil?
		BCrypt::Password.new(digest).is_password?(token)
	end
# Returns the hash digest of the given string.
	def digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end

end


