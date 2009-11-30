class MoveVerifiedTasksIntoSeparateRelease < ActiveRecord::Migration
  def self.up
    release = Release.create!
    release.tasks = Task.verified
    release.update_attribute :finished_at, release.tasks.maximum(:completed_on)
  end

  def self.down
  end
end
