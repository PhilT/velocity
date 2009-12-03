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
    last[0].tasks.features.count rescue '(none)'
  end

end

