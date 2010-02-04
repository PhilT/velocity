class Story < ActiveRecord::Base
  acts_as_list :scope => :release

  has_many :tasks
  has_and_belongs_to_many :stakeholders, :class_name => 'User', :foreign_key => :stakeholder_id
  belongs_to :release

  def state
    'pending'
  end
end
