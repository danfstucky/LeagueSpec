class AddRequestRespondedAtToFriendships < ActiveRecord::Migration
  def change
    add_column :friendships, :request_responded_at, :datetime
  end
end
