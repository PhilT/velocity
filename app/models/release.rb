class Release < ActiveRecord::Base
  has_many :tasks
  has_many :stories
  belongs_to :finished_by, :class_name => 'User', :foreign_key => :finished_by

  named_scope :previous, :order => 'created_at DESC'

  delegate :features, :bugs, :refactorings, :to => :tasks

  def self.finish!(user)
    return false unless can_complete_release?
    release = Release.create(:finished_by => user)
    Task.current.without_story.verified.each do |task|
      task.add_to_release!(release)
    end
    Task.current.without_story.invalid.each do |task|
      task.add_to_release!(release)
    end

    ReleaseMailer.deliver_release_notification(User.all, release)
  end

  def self.velocity
    last.try(:velocity) || 0
  end

  def velocity
    begin
      releases = Release.previous(:limit => 2)
      distance_in_minutes = (((releases[0].created_at - releases[1].created_at).abs)/60)
      days = (distance_in_minutes / 1440)
      (self.tasks.features.verified.count / days * 7).to_i
    rescue
      0
    end
  end

  def self.can_complete_release?
    !(Task.current.without_story.completed.any?)
  end

end

