class ReplaceWhenConceptWithPositionAndNowFlag < ActiveRecord::Migration
  def self.up
    change_table :tasks do |t|
      t.column :category, :string
      t.column :position, :integer
      t.column :now, :boolean, :default => false
    end

    now_tasks = Task.all(:conditions => 'when_id = 286043344')
    @@position = 0
    now_tasks.each do |task|
      update(task)
    end

    later_tasks = Task.all(:conditions => 'when_id != 286043344')
    later_tasks.each do |task|
      update(task)
    end

    change_table :tasks do |t|
      t.remove :when_id
      t.remove :category_id
      t.remove :effort_id
    end

  end

  def self.update(task)
    task.category = {534213990 => 'feature', 1079508512 => 'refactor', 898416404 => 'bug', }[task.category_id]
    task.position = @@position
    task.now = true if task.when_id = 286043344
    @@position += 1
    task.save!
  end

  def self.down
    change_table :tasks do |t|
      t.remove :category
      t.remove :position
      t.remove :now
      t.column :when_id, :integer
      t.column :category_id, :integer
      t.column :effort_id, :integer
    end
  end
end

