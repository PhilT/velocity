class Project
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :created_on, Date

  has n, :tasks
end

