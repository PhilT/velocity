class AddReleaseModel < ActiveRecord::Migration
  def self.up
    create_table :releases do |t|
      t.datetime :finished_at
    end
    add_column :tasks, :release_id, :integer
    current_release = Release.create!
    tasks = Task.all(:conditions => {:now => true})
    current_release.tasks = Task.all(:conditions => {:now => true})
    current_release.save!
    remove_column :tasks, :now
  end

  def self.down
  end
end

