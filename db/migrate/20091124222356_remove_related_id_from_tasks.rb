class RemoveRelatedIdFromTasks < ActiveRecord::Migration
  def self.up
    remove_column :tasks, :related_id
  end

  def self.down
    add_column :tasks, :related_id, :integer
  end
end

