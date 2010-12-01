class RenameReleaseIdToActiveInGroups < ActiveRecord::Migration
  def self.up
    rename_column :stories, :release_id, :active
    change_column :stories, :active, :boolean, :default => true
    execute('UPDATE stories SET active = 1')
  end

  def self.down
    change_column :stories, :active, :integer
    rename_column :stories, :active, :release_id
  end
end
