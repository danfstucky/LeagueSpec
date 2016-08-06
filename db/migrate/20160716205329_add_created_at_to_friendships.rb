class AddCreatedAtToFriendships < ActiveRecord::Migration
  def change
    add_column :friendships, :created_at, :datetime
  end
end
