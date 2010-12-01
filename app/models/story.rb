class Story < ActiveRecord::Base
  has_many :tasks
  belongs_to :release

  default_scope :order => :name
  named_scope :created, lambda {{:conditions => ["created_at > ?", Task.last_poll]}}
  named_scope :current, :conditions => {:active => true}
  named_scope :orphaned, :conditions => ['id NOT IN (SELECT story_id FROM tasks WHERE story_id IS NOT NULL)']

  validates_uniqueness_of :name

  def self.remove_orphans
    orphaned.destroy_all
  end

  def activate
    self.active = true
  end
end

