class Task < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User', :foreign_key => :created_by
  belongs_to :assigned_to, :class_name => 'User', :foreign_key => :assigned_to
  
  belongs_to :duplicate => :class_name => 'Task', :foreign_key => :duplicate_of
  has_many :duplicates => :class_name => 'Task', :foreign_key => :duplicate_of

  validates_inclusion_of :category, :in => %w( feature bug change )
  validates_inclusion_of :when, :in => %w( now soon later )
  validates_inclusion_of :effort, :in => [1, 2, 4, 8]

  default_scope :order => '', :group => 
end