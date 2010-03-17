class RemoveCurrentRelease < ActiveRecord::Migration
  def self.up
    current_release = Release.first(:conditions => {:finished_at => nil})
    task_max_position = current_release.tasks.maximum(:position)
    execute("UPDATE tasks SET position = position + #{task_max_position} WHERE release_id IS NULL")
    execute("UPDATE tasks SET release_id = NULL WHERE release_id = #{Release.current.id}")

    story_max_position = current_release.stories.maximum(:position)
    execute("UPDATE stories SET position = position + #{story_max_position} WHERE release_id IS NULL")
    execute("UPDATE stories SET release_id = NULL WHERE release_id = #{Release.current.id}")

    Release.current.destroy
  end

  def self.down
    Release.create!
  end
end
