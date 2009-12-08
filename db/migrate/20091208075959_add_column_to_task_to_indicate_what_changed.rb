class AddColumnToTaskToIndicateWhatChanged < ActiveRecord::Migration
  def self.up
    add_column :tasks, :updated_field, :string
  end

  def self.down
    remove_column :tasks, :update_field
  end
end

