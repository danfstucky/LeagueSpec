module Tokenizer
  # Returns true if the given token matches the digest.
	def authenticated?(attribute, token)
		digest = send("#{attribute}_digest")
		return false if digest.nil?
		#return false if remember_digest.nil?
		BCrypt::Password.new(digest).is_password?(token)
	end
end
