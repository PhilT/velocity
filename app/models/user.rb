class User < ActiveRecord::Base
  acts_as_authentic

  has_many :created_tasks, :class_name => 'Task', :foreign_key => :author_id
  has_many :assigned_tasks, :class_name => 'Task', :foreign_key => :assigned_id
  has_many :verified_tasks, :class_name => 'Task', :foreign_key => :verified_by

  scope :developers, where(:developer => true)
  scope :non_developers, where(:developer => false)

  has_and_belongs_to_many :stories

  def admin
    self.first
  end

  def email_address_with_name
    "#{name} <#{email}>"
  end

  def initials
    self.name.split(' ').map{|word| word.chars.first}.join
  end
end

