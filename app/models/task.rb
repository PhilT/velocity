class Task < ActiveRecord::Base
  belongs_to :author, :class_name => 'User', :foreign_key => :author_id
  belongs_to :assigned, :class_name => 'User', :foreign_key => :assigned_id

  belongs_to :related, :class_name => 'Task', :foreign_key => :related_id
  has_many :relateds, :class_name => 'Task', :foreign_key => :related_id

  belongs_to :category, :class_name => 'EnumValue', :foreign_key => :category_id
  belongs_to :when, :class_name => 'EnumValue', :foreign_key => :when_id
  belongs_to :effort, :class_name => 'EnumValue', :foreign_key => :effort_id

  validates_presence_of :author
  validates_presence_of :category
  validates_presence_of :when

  named_scope :active, :conditions => {:completed_on => nil}
  named_scope :now, :conditions => {:started_on => nil, :completed_on => nil, :enum_values => {:name => 'now'}}, :joins => :when
  named_scope :soon, :conditions => {:started_on => nil, :completed_on => nil, :enum_values => {:name => 'soon'}}, :joins => :when
  named_scope :later, :conditions => {:started_on => nil, :completed_on => nil, :enum_values => {:name => 'later'}}, :joins => :when

  named_scope :started, :conditions => "started_on IS NOT NULL AND completed_on IS NULL"
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

