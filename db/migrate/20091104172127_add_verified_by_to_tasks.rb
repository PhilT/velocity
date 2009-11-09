class AddVerifiedByToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :verified_by, :integer
  end

  def self.down
    remove_column :tasks, :verified_by
  end
end
