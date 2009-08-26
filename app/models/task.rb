class Task < ActiveRecord::Base
  belongs_to :author, :class_name => 'User', :foreign_key => :author_id
  belongs_to :assigned_to, :class_name => 'User', :foreign_key => :assigned_to_id
  
  belongs_to :duplicate, :class_name => 'Task', :foreign_key => :duplicate_id
  has_many :duplicates, :class_name => 'Task', :foreign_key => :duplicate_id

  belongs_to :category, :class_name => 'EnumValue', :foreign_key => :category_id
  belongs_to :when, :class_name => 'EnumValue', :foreign_key => :when_id
  belongs_to :effort, :class_name => 'EnumValue', :foreign_key => :effort_id

  validates_presence_of :author
  validates_presence_of :category
  validates_presence_of :when
  
  named_scope :active, :conditions => {:completed_on => nil}
  named_scope :now, :conditions => {:completed_on => nil, :enum_values => {:value => 'Now'}}, :joins => :when
  named_scope :soon, :conditions => {:completed_on => nil, :enum_values => {:value => 'Soon'}}, :joins => :when
  named_scope :later, :conditions => {:completed_on => nil, :enum_values => {:value => 'Later'}}, :joins => :when

  named_scope :completed, :conditions => "completed_on IS NOT NULL"
  
  def started?
    !self.started_on.blank?
  end
  
  def started
    started?
  end
  
  def started=(value)
     value ? touch(:started_on) : self.started_on = nil
  end

  def completed?
    !self.completed_on.blank?
  end
  
  def completed
    self.completed?
  end
  
  def completed=(value)
     value ? touch(:completed_on) : self.completed_on = nil
  end
end