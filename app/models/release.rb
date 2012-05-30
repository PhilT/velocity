class Release
  include DataMapper::Resource
  property :id, Serial
  property :created_at, DateTime

  has n, :tasks
  has n, :groups
  belongs_to :finished_by, 'User'
end

