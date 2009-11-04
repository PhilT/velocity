class User < ActiveRecord::Base
  acts_as_authentic

  has_many :created_tasks, :class_name => 'Task', :foreign_key => :author_id
  has_many :assigned_tasks, :class_name => 'Task', :foreign_key => :assigned_id

  named_scope :developers, :conditions => {:developer => true}

  def admin
    self.first
  end
end

