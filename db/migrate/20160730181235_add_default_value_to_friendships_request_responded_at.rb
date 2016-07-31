class AddDefaultValueToFriendshipsRequestRespondedAt < ActiveRecord::Migration
  def change
  	change_column_default :friendships, :request_responded_at, nil
  end
end
