class AddDefaultValueToUsersLoggedIn < ActiveRecord::Migration
  def change
  	change_column_default :users, :logged_in, '1900-01-01 00:00:00'
  end
end
