class RemoveFinishedAtFromReleases < ActiveRecord::Migration
  def self.up
    remove_column :releases, :created_at
    rename_column :releases, :finished_at, :created_at
  end

  def self.down
  end
end

