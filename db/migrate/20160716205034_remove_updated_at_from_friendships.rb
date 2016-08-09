class RemoveUpdatedAtFromFriendships < ActiveRecord::Migration
  def change
    remove_column :friendships, :updated_at, :datetime
  end
end
