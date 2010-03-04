class Release < ActiveRecord::Base
  has_many :tasks
  has_many :stories
  belongs_to :finished_by, :class_name => 'User', :foreign_key => :finished_by

  named_scope :previous, :conditions => 'finished_at IS NOT NULL', :order => 'finished_at DESC'
  named_scope :last, :conditions => 'finished_at IS NOT NULL', :order => 'finished_at DESC', :limit => 1

  delegate :features, :bugs, :refactorings, :to => :tasks

  def self.current
    find_by_finished_at(nil)
  end

  def current?
    self.finished_at.nil?
  end

  def finish!(user)
    return false if tasks.without_story.completed.any?

    touch :finished_at
    update_attribute :finished_by, user
    new_release = Release.create!
    new_release.tasks = tasks.without_story.incomplete
    index = 0
    stories.each do |story|
      story.move_to!(index += 1, new_release, user) if story.incomplete?
    end
    new_release.save!

    ReleaseMailer.deliver_release_notification(User.all, self)
  end

  def self.velocity
    last[0].try(:velocity) || 0
  end

  def velocity
    begin
      distance_in_minutes = (((self.finished_at - self.created_at).abs)/60)
      days = (distance_in_minutes / 1440)
      tasks_per_week = self.tasks.features.count / days * 7
      tasks_per_week > 1 ? tasks_per_week.round : 'less than 1'
    rescue
      '(none)'
    end
  end

end

