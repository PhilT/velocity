class Story < ActiveRecord::Base
  has_many :tasks
  has_and_belongs_to_many :stakeholders, :class_name => 'User', :foreign_key => :stakeholder_id
end
