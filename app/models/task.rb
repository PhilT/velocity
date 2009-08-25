class Task < ActiveRecord::Base
  belongs_to :author, :class_name => 'User', :foreign_key => :author_id
  belongs_to :assigned_to, :class_name => 'User', :foreign_key => :assigned_to
  
  belongs_to :duplicate, :class_name => 'Task', :foreign_key => :duplicate_of
  has_many :duplicates, :class_name => 'Task', :foreign_key => :duplicate_of

  belongs_to :category, :class_name => 'EnumValue', :readonly => true
  belongs_to :when, :class_name => 'EnumValue', :readonly => true
  belongs_to :effort, :class_name => 'EnumValue', :readonly => true

  validates_presence_of :author
  validates_presence_of :category
  validates_presence_of :when
end