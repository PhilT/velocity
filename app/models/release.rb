class Release < ActiveRecord::Base
  has_many :tasks

  named_scope :previous, :conditions => 'finished_at IS NOT NULL', :order => 'finished_at DESC'
  named_scope :last, :conditions => 'finished_at IS NOT NULL', :order => 'finished_at DESC', :limit => 1

  def self.current
    find_by_finished_at(nil)
  end

  def current?
    self.finished_at.nil?
  end

  def finish!
    ReleaseMailer.deliver_release_notification(User.all, self)

    touch :finished_at
    Release.create!
  end

  def self.velocity
    begin
      release = last[0]

      distance_in_minutes = (((release.finished_at - release.created_at).abs)/60)
      days = (distance_in_minutes / 1440)
      tasks_per_week = release.tasks.features.count / days * 7
      tasks_per_week > 1 ? tasks_per_week.round : 'less than 1'
    rescue
      '(none)'
    end
  end

end

