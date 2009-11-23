class ReplaceWhenConceptWithPositionAndNowFlag < ActiveRecord::Migration
  def self.up
    change_table :tasks do |t|
      t.column :bug, :boolean, :default => false
      t.column :position, :integer
      t.column :now, :boolean, :default => false
    end

    tasks = Task.all(:conditions => 'when_id = 286043344')
    @@position = 0
    tasks.each do |task|
      update(task)
    end

    tasks = Task.all(:conditions => 'when_id != 286043344')
    tasks.each do |task|
      update(task)
    end

    change_table :tasks do |t|
      t.remove :when_id
      t.remove :category_id
      t.remove :effort_id
    end

  end

  def self.update(task)
    task.bug = true if task.category_id = 898416404
    task.position = @@position
    task.now = true if task.when_id = 286043344
    @@position += 1
    task.save!
  end

  def self.down
    change_table :tasks do |t|
      t.remove :bug
      t.remove :position
      t.remove :now
      t.column :when_id, :integer
      t.column :category_id, :integer
      t.column :effort_id, :integer
    end
  end
end

