class RemoveDetailField < ActiveRecord::Migration
  def self.up
    remove_column :tasks, :detail
    change_column :tasks, :name, :text
  end

  def self.down
    add_column :tasks, :detail, :string
    change_column :tasks, :name, :string
  end
end

