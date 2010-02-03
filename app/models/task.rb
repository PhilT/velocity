class Task < ActiveRecord::Base
  include AASM
  acts_as_list :scope => :release

  before_create :set_initial_state

  belongs_to :author, :class_name => 'User', :foreign_key => :author_id
  belongs_to :assigned, :class_name => 'User', :foreign_key => :assigned_id
  belongs_to :verifier, :class_name => 'User', :foreign_key => :verified_by
  belongs_to :release
  belongs_to :story

  validates_presence_of :name

  aasm_column :state
  aasm_state :pending
  aasm_state :started, :after_enter => :mark_started
  aasm_state :completed, :after_enter => :mark_completed
  aasm_state :verified
  aasm_state :invalid

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
  aasm_event :mark_invalid do
    transitions :from => [:pending, :started, :completed], :to => :invalid
  end
  aasm_event :mark_valid do
    transitions :from => :invalid, :to => :pending
  end
  aasm_event :next_state do
    transitions :from => :pending, :to => :started
    transitions :from => :started, :to => :completed
    transitions :from => :completed, :to => :verified
    transitions :from => :verified, :to => :started
    transitions :from => :invalid, :to => :pending
  end

  default_scope :order => :position
  named_scope :current, :conditions => 'releases.finished_at IS NULL', :joins => [:release]
  named_scope :future, :conditions => "release_id IS NULL"
  named_scope :features, :conditions => {:category => 'feature'}
  named_scope :bugs, :conditions => {:category => 'bug'}
  named_scope :refactorings, :conditions => {:category => 'refactor'}
  named_scope :outstanding, :conditions => 'state != "verified"'
  named_scope :created, lambda {|user|{:conditions => ["created_at > ? AND author_id != ?", last_poll, user.id]}}
  named_scope :updated, lambda {{:conditions => ["updated_at > ?", last_poll]}}
  named_scope :incomplete, :conditions => {:state => ['pending', 'started']}
  named_scope :completed, :conditions => {:state => 'completed'}

  def self.last_poll
    DateTime.now - 29.seconds
  end

  def self.other_updates?(user)
    updated_tasks = Release.current.tasks.updated + self.future.updated
    updated_tasks.each do |task|
      return true if task.updated_field == 'position' && task.updated_by != user
    end
    return false
  end

  def self.assigned_to(user)
    updated_tasks = Release.current.tasks.updated + self.future.updated
    updated_tasks.reject{|task| task.updated_field != 'assigned' || task.updated_by != user}
  end

  def invalidate!(user)
    self.mark_invalid
    update_attribute(:assigned, user)
  end

  def started
    started?
  end

  def previous_release?
    release_id && !release.current?
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
    update_attributes(:assigned => user, :updated_field => ['assigned', user.id].join(','))
  end

  def verified_by!(user)
    update_attribute :verified_by, user.id
  end

  def set_initial_state
    self.state = 'pending'
  end

  def action
    self.release ? (aasm_events_for_current_state - [:mark_invalid, :next_state]).first.to_s.gsub('_', ' ') : 'to current'
  end

  def move_to!(position, release, user)
    update_attributes(:position => position, :release => release, :updated_field => ['position', user.id].join(','))
  end

  def updated_field
    self['updated_field'].split(',')[0]
  end

  def updated_by
    user_id = self['updated_field'].split(',')[1]
    User.find(user_id.to_i) unless user_id.blank?
  end

  def mark_started
    self.started_on = current_time_from_proper_timezone
    self.completed_on = nil
  end

  def mark_completed
    self.completed_on = current_time_from_proper_timezone
  end

  def next_category!
    categories = %w(feature bug refactor)
    i = categories.index(self.category) + 1
    i = 0 if i == categories.size
    update_attribute(:category, categories[i])
  end

end

