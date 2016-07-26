class AddDefaultValueToUsersLoggedIn < ActiveRecord::Migration
  def change
  	change_column_default :users, :logged_in, false
  	change_column_default :users, :last_logged_in, '1900-01-01 00:00:00'
  end
end
