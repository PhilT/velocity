class User
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :created_at, DateTime
  property :updated_at, DateTime
  property :email, String
  property :developer, Boolean, :default => false


  has n, :created_tasks, 'Task', :child_key => :author_id
  has n, :assigned_tasks, 'Task', :child_key => :assigned_id
  has n, :verified_tasks, 'Task', :child_key => :verified_by
end

