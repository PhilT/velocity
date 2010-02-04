class CreateStakeholdersStories < ActiveRecord::Migration
  def self.up
    create_table :stakeholders_stories, :id => false do |t|
      t.integer :stakeholder_id
      t.integer :story_id
    end
  end

  def self.down
    drop_table :stakeholders_stories
  end
end
