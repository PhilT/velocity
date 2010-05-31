class AddDefaultToCategory < ActiveRecord::Migration
  def self.up
    change_column :tasks, :category, :string, :default => 'feature'
  end

  def self.down
    change_column :tasks, :category, :string, :default => nil
  end
end

