class Story < ActiveRecord::Base
  has_many :tasks
end
