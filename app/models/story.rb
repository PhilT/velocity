class Story < ActiveRecord::Base
  acts_as_list :scope => :release

  has_many :tasks, :order => :position
  has_and_belongs_to_many :stakeholders, :class_name => 'User', :foreign_key => :stakeholder_id
  belongs_to :release

  named_scope :future, :conditions => ['release_id IS NULL']

  def state
    task_states = self.tasks.map(&:state).uniq
    if task_states == ['pending']
      'pending'
    elsif task_states - ['completed', 'verified'] == []
      'completed'
    elsif task_states == ['verified']
      'verified'
    else 
      'started'
    end
  end

  def move_to!(position, release, user)
    update_attributes(:position => position, :release => release)
  end
end

