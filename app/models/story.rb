class Story < ActiveRecord::Base
  named_scope :created, lambda {{:conditions => ["created_at > ?", Task.last_poll]}}

  default_scope :order => :name
  validates_uniqueness_of :name, :scope => :release_id
end

