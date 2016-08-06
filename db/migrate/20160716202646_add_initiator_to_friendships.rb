class AddInitiatorToFriendships < ActiveRecord::Migration
  def change
    add_column :friendships, :initiator, :boolean, :default => false
  end
end
