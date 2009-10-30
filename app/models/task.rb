class Task < ActiveRecord::Base
  include AASM

  before_create :set_initial_state

  belongs_to :author, :class_name => 'User', :foreign_key => :author_id
  belongs_to :assigned, :class_name => 'User', :foreign_key => :assigned_id

  belongs_to :related, :class_name => 'Task', :foreign_key => :related_id
  has_many :relateds, :class_name => 'Task', :foreign_key => :related_id

  belongs_to :category, :class_name => 'EnumValue', :foreign_key => :category_id
  belongs_to :when, :class_name => 'EnumValue', :foreign_key => :when_id
  belongs_to :effort, :class_name => 'EnumValue', :foreign_key => :effort_id

  validates_presence_of :name
  validates_presence_of :author
  validates_presence_of :category
  validates_presence_of :when

  aasm_column :state
  aasm_state :pending
  aasm_state :started, :enter => :timestamp
  aasm_state :completed, :enter => :timestamp
  aasm_state :verified

  aasm_event :start do
    transitions :from => :pending, :to => :started
  end
  aasm_event :complete do
    transitions :from => :started, :to => :completed
  end
  aasm_event :verify do
    transitions :from => :completed, :to => :verified
  end
  aasm_event :restart do
    transitions :from => :verified, :to => :started
  end
  aasm_event :next_state do
    transitions :from => :pending, :to => :started
    transitions :from => :started, :to => :completed
    transitions :from => :completed, :to => :verified
    transitions :from => :verified, :to => :started
  end

  named_scope :active, :conditions => {:completed_on => nil}
  named_scope :now, :conditions => {:started_on => nil, :completed_on => nil, :enum_values => {:name => 'now'}}, :joins => :when
  named_scope :soon, :conditions => {:started_on => nil, :completed_on => nil, :enum_values => {:name => 'soon'}}, :joins => :when
  named_scope :later, :conditions => {:started_on => nil, :completed_on => nil, :enum_values => {:name => 'later'}}, :joins => :when

  named_scope :completed, :conditions => ["completed_on IS NOT NULL AND ? <= completed_on", Date.today - 14.days], :order => 'completed_on DESC'

  def started
    started?
  end

  def started=(value)
     Boolean.parse(value) ? touch(:started_on) : self.started_on = nil
  end

  def completed
    completed?
  end

  def completed=(value)
     Boolean.parse(value) ? touch(:completed_on) : self.completed_on = nil
  end

  def assign_to!(user)
    update_attribute :assigned_id, user.id
  end

  def set_initial_state
    self.state = 'pending'
  end

  def action
    (aasm_events_for_current_state - [:next_state]).first
  end

  def timestamp
    self.update_attribute "#{state}_on", Time.now rescue nil
  end
end

