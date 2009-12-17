class AddFinishedByToReleases < ActiveRecord::Migration
  def self.up
    add_column :releases, :finished_by, :integer
    execute('UPDATE releases SET finished_by = 1')
  end

  def self.down
    remove_column :releases, :finished_by
  end
end

