class RemoveCurrentRelease < ActiveRecord::Migration
  def self.up
    current_release = Release.find_by_finished_at(nil)
    task_max_position = current_release.tasks.maximum(:position) || 0
    execute("UPDATE tasks SET position = position + #{task_max_position} WHERE release_id IS NULL")
    execute("UPDATE tasks SET release_id = NULL WHERE release_id = #{current_release.id}")

    story_max_position = current_release.stories.maximum(:position) || 0
    execute("UPDATE stories SET position = position + #{story_max_position} WHERE release_id IS NULL")
    execute("UPDATE stories SET release_id = NULL WHERE release_id = #{current_release.id}")

    current_release.destroy
  end

  def self.down
    Release.create!
  end
end

