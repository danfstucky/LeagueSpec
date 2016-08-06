class ChangeFriendshipStatusDefaultInFriendships < ActiveRecord::Migration
  def change
    change_column_default :friendships, :friendship_status, 1
  end
end
