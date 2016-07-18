class AddFriendshipStatusToFriendships < ActiveRecord::Migration
  def change
    add_column :friendships, :friendship_status, :integer, :default => 1
  end
end
