class Release < ActiveRecord::Base
  has_many :tasks
  has_many :stories
  belongs_to :finished_by, :class_name => 'User', :foreign_key => :finished_by

  named_scope :previous, :conditions => 'finished_at IS NOT NULL', :order => 'finished_at DESC'
  named_scope :last, :conditions => 'finished_at IS NOT NULL', :order => 'finished_at DESC', :limit => 1

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
    last[0].try(:velocity) || 0
  end

  def velocity
    begin
      distance_in_minutes = (((self.finished_at - self.created_at).abs)/60)
      days = (distance_in_minutes / 1440)
      tasks_per_week = self.tasks.features.verified.count / days * 7
      tasks_per_week > 1 ? tasks_per_week.round : 'less than 1'
    rescue
      '(none)'
    end
  end

  def can_complete_release?
    !(Task.current.without_story.completed.any?)
  end

end

