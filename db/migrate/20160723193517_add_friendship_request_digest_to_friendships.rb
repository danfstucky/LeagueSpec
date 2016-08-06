class AddFriendshipRequestDigestToFriendships < ActiveRecord::Migration
  def change
    add_column :friendships, :friendship_request_digest, :string
  end
end
