class Friendship < ActiveRecord::Base
  extend TokenContext
  include Tokenizer
	enum friendship_status: [ :denied, :pending, :accepted]
  attr_accessor :friendship_request_token
	cattr_accessor :daily_request_limit
  @@daily_request_limit = 12
  belongs_to :user, foreign_key: 'user_id', class_name: 'User'
  belongs_to :friend, foreign_key: 'friend_id', class_name: 'User' 
  validates_presence_of   :user
  validates_presence_of   :friend
  validates_uniqueness_of :friend_id, scope: :user_id
  validate :cannot_request_if_daily_limit_reached
  validates_each :user_id do |record, attr, value|
    record.errors.add attr, 'can not be same as friend' if record.user_id.eql?(record.friend_id)
  end
  before_create :create_friendship_request_digest

  

  def cannot_request_if_daily_limit_reached  
    if new_record? && initiator && user.has_reached_daily_friend_request_limit?
      errors.add(:base, "Daily friends request limit exceeded. Sorry, you'll have to wait a little while before requesting any more friendships.") 
    end
  end 

  def reverse
    Friendship.where('user_id = ? and friend_id = ?', self.friend_id, self.user_id).first
  end

  def self.friends?(user, friend)
    Friendship.exists?(user_id: user.id, friend_id: friend.id, friendship_status: 2)
  end

  def self.denied_friendship?(user, friend)
    Friendship.exists?(user_id: user.id, friend_id: friend.id, friendship_status: 0)
  end

  def self.pending_friendship?(user, friend)
    Friendship.exists?(user_id: user.id, friend_id: friend.id, friendship_status: 1)
  end




  # Sends a friend request email
	def send_friend_request_email
		UserMailer.friendship_request(self).deliver_now
	end

  def create_friendship_request_digest
    self.friendship_request_token = Friendship.new_token
    self.friendship_request_digest = Friendship.digest(friendship_request_token)
  end

  def accept_friend_request
    update(friendship_status: 2, request_responded_at: Time.zone.now)
  end

  def deny_friend_request
    update(friendship_status: 0, request_responded_at: Time.zone.now)
  end


end
