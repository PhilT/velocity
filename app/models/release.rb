class Release < ActiveRecord::Base
  has_many :tasks
  has_many :stories
  belongs_to :finished_by, :class_name => 'User', :foreign_key => :finished_by

  named_scope :previous, :conditions => 'finished_at IS NOT NULL', :order => 'finished_at DESC'

  delegate :features, :bugs, :refactorings, :to => :tasks

  def finish!(user)
    return false unless can_complete_release?

    Task.current.without_story.verified.each do |task|
      task.add_to_release!(self)
    end
    Story.current.verified.each do |story|
      story.add_to_release!(self)
      story.tasks.each {|task| task.add_to_release!(self)}
    end

    touch :finished_at
    update_attribute :finished_by, user

    ReleaseMailer.deliver_release_notification(User.all, self)
  end

  def self.velocity
    last.try(:velocity) || 0
  end

  def velocity
    begin
      releases = Release.all(:limit => 2, :order => 'created_at DESC')
      distance_in_minutes = (((releases[0].created_at - releases[1].created_at).abs)/60)
      days = (distance_in_minutes / 1440)
      self.tasks.features.verified.count / days * 7
    rescue
      0
    end
  end

  def can_complete_release?
    !(Task.current.without_story.completed.any?)
  end

end

