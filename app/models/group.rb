class Group
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :created_at, DateTime
  property :active, Boolean

  has n, :tasks
  belongs_to :release
end

