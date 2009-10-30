class AddStates < ActiveRecord::Migration
  def self.up
    Task.all.each do |task|
      if task.started_on.nil?
        task.state = 'pending'
      elsif task.completed_on.nil?
        task.state = 'started'
      else
        task.state = 'completed'
      end
      task.save
    end
  end

  def self.down
  end
end

