class User < ActiveRecord::Base
  has_many :created_tasks, :class_name => 'Task', :foreign_key => :created_by
  has_many :assigned_tasks, :class_name => 'Task', :foreign_key => :assigned_to

  validates_inclusion_of :kind, :in => %w( customer developer )
end
