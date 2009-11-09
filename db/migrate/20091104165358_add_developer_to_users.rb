class AddDeveloperToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :developer, :boolean, :default => false
    remove_column :users, :access_level_id

    User.all.map{|user| user.update_attribute :developer, true}
  end

  def self.down
    remove_column :users, :developer
    add_column :users, :access_level_id, :integer
  end
end
