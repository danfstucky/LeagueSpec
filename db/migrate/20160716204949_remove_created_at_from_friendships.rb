class RemoveCreatedAtFromFriendships < ActiveRecord::Migration
  def change
    remove_column :friendships, :created_at, :datetime
  end
end
