class AddFieldsToStories < ActiveRecord::Migration
  def self.up
    add_column :stories, :customers, :string, :limit => 500
    add_column :stories, :due_on, :date
    add_column :stories, :soft_release_on, :date
  end

  def self.down
    remove_columns :stories, :customers, :due_on, :soft_release_on
  end
end
