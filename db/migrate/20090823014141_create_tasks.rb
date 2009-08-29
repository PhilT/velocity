class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.string    :name
      t.string    :detail
      t.timestamps
      t.datetime  :started_on
      t.datetime  :completed_on
      t.integer   :author_id
      t.integer   :assigned_id
      t.integer   :related_id
      t.integer   :category_id
      t.integer   :when_id
      t.integer   :effort_id
    end
  end

  def self.down
    drop_table :tasks
  end
end

