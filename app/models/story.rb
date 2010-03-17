class Story < ActiveRecord::Base
  acts_as_list :scope => :release

  has_many :tasks, :order => :position
  has_and_belongs_to_many :stakeholders, :class_name => 'User', :foreign_key => :stakeholder_id
  belongs_to :release

  named_scope :current, :conditions => ['release_id IS NULL']

  def state
    task_states = self.task_states
    if task_states == ['pending']
      'pending'
    elsif (task_states - ['verified', 'invalid']).empty?
      'verified'
    elsif (task_states - ['completed', 'verified', 'invalid']).empty?
      'completed'
    else
      'started'
    end
  end

  def task_states
    self.tasks.map(&:state).uniq
  end

  def move_to!(position, release, user)
    if self.release != release
      self.tasks.each_with_index do |task, index|
        task.move_to!(index, release, user)
      end
    end
    self.update_attributes(:position => position, :release => release)
  end

  def incomplete?
    ['pending', 'started'].include?(self.state)
  end

  def completed?
    self.state == 'completed'
  end
end

