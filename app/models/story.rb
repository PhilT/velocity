class Story < ActiveRecord::Base
  has_many :tasks
  belongs_to :release

  default_scope :order => :name
  named_scope :created, lambda {{:conditions => ["created_at > ?", Task.last_poll]}}
  named_scope :current, :conditions => ['release_id IS NULL']

  validates_uniqueness_of :name, :scope => :release_id
end

