class User < ActiveRecord::Base
  has_many :created_tasks, :class_name => 'Task', :foreign_key => :author_id
  has_many :assigned_tasks, :class_name => 'Task', :foreign_key => :assigned_id

  belongs_to :access_level, :class_name => 'EnumValue', :foreign_key => :access_level_id, :readonly => true

  named_scope :developers, :conditions => {:enum_values => {:name => 'developer'}}, :joins => :access_level
end

