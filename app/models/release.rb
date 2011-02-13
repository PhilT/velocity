class Release < ActiveRecord::Base
  has_many :tasks
  has_many :stories
  belongs_to :finished_by, :class_name => 'User', :foreign_key => :finished_by

  validates_presence_of :finished_by
  validate :tasks_state

  scope :previous, order('created_at DESC')

  delegate :features, :bugs, :refactorings, :to => :tasks

  after_create :send_notification

  def initialize(attributes = {})
    super
    self.tasks = Task.current.verified + Task.current.invalid
  end

  def tasks_state
    errors.add 'tasks', 'merged but not verified' if Task.current.merged.any?
    errors.add 'tasks', 'not verified' unless self.tasks.any?
  end

  def send_notification
    ReleaseMailer.release_notification(User.all, self).deliver
  end

  def self.velocity
    last.try(:velocity) || 0
  end

  def velocity
    begin
      releases = Release.previous.where(['created_at <= ?', self.created_at]).limit(2)
      distance_in_minutes = (((releases[0].created_at - releases[1].created_at).abs)/60)
      days = (distance_in_minutes / 1440)
      (self.tasks.features.verified.count / days * 7).to_i
    rescue
      0
    end
  end

  def created_at_in_ms
    self.created_at.to_i * 1000
  end

end

