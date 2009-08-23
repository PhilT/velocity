class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.string    :name
      t.string    :detail
      t.timestamps
      t.datetime  :started_on
      t.datetime  :completed_on
      t.integer   :created_by
      t.integer   :assigned_to
      t.integer   :duplicate_of
      t.string    :category
      t.string    :when
      t.integer   :effort
    end
  end

  def self.down
    drop_table :tasks
  end
end
