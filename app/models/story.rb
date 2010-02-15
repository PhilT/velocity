class Story < ActiveRecord::Base
  acts_as_list :scope => :release

  has_many :tasks
  has_and_belongs_to_many :stakeholders, :class_name => 'User', :foreign_key => :stakeholder_id
  belongs_to :release

  named_scope :open, :conditions => ['release_id = ? OR release_id IS NULL', Release.current.id]

  def state
    'pending'
  end

  def move_to!(position, release, user)
    update_attributes(:position => position, :release => release)
  end
end
