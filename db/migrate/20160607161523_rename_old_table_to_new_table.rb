class RenameOldTableToNewTable < ActiveRecord::Migration
  def change
    rename_table :clients, :summoners
  end 
end
