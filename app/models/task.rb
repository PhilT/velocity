class Task
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :created_at, DateTime
  property :updated_at, DateTime
  property :started_on, Date
  property :completed_on, Date
  property :state, String
  property :category, String, :default => 'feature'
  property :position, Integer
  property :updated_field, String

  belongs_to :author, 'User', :child_key => :author_id
  belongs_to :assigned, 'User', :child_key => :assigned_id
  belongs_to :verifier, 'User', :child_key => :verified_by
  belongs_to :release
  belongs_to :group, :required => false
  belongs_to :project
end

