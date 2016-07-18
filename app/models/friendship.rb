class Friendship < ActiveRecord::Base
	enum friendship_status: [ :denied, :pending, :accepted]
	@@daily_request_limit = 12
  cattr_accessor :daily_request_limit

	belongs_to :user, :foreign_key => "user_id", :class_name => "User"
  belongs_to :friend, :foreign_key => "friend_id", :class_name => "User" 
  validates_presence_of   :user
  validates_presence_of   :friend
  validates_uniqueness_of :friend_id, :scope => :user_id
  validate :cannot_request_if_daily_limit_reached
  validates_each :user_id do |record, attr, value|
    record.errors.add attr, 'can not be same as friend' if record.user_id.eql?(record.friend_id)
  end
  


  def cannot_request_if_daily_limit_reached  
    if new_record? && initiator && user.has_reached_daily_friend_request_limit?
      errors.add(:base, "Sorry, you'll have to wait a little while before requesting any more friendships.") 
    end
  end 

  def reverse
    Friendship.where('user_id = ? and friend_id = ?', self.friend_id, self.user_id).first
  end

  def denied?
    friendship_status.eql?(0)
  end
  
  def pending?
    friendship_status.eql?(1)
  end
  
  def accepted?
    friendship_status.eql?(2)    
  end
  
  def self.friends?(user, friend)
    where("user_id = ? AND friend_id = ? AND friendship_status = ?", user.id, friend.id, 2).first
  end

  # Sends a friend request email
	def send_friend_request_email
		UserMailer.friendship_request(self).deliver_now
	end

end
