class SimplifyStories < ActiveRecord::Migration
  def self.up
    drop_table :stakeholders_stories
    remove_column :stories, :customers
  end

  def self.down
    create_table :stakeholders_stories, :id => false do |t|
      t.integer :stakeholder_id
      t.integer :story_id
    end

    add_column :stories, :due_on, :date
    add_column :stories, :soft_release_on, :date
  end
end

