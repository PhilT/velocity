class RemoveColumnsFromStory < ActiveRecord::Migration
  def self.up
    change_table :stories do |t|
      t.remove :due_on
      t.remove :updated_at
      t.remove :soft_release_on
      t.remove :position
      t.remove :description
    end
  end

  def self.down
  end
end

