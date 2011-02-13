class Story < ActiveRecord::Base
  has_many :tasks
  belongs_to :release

  default_scope :order => :name
  scope :created, lambda { where(["created_at > ?", Task.last_poll]) }
  scope :current, where(:active => true)
  scope :orphaned, where('id NOT IN (SELECT story_id FROM tasks WHERE story_id IS NOT NULL AND release_id IS NULL)')

  validates_uniqueness_of :name

  def self.remove_orphans
    self.orphaned.update_all('active = 0')
  end

  def activate
    self.active = true
  end
end

