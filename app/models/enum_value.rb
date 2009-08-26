class EnumValue < ActiveRecord::Base
  belongs_to :enum
  default_scope :order => 'position'
end
