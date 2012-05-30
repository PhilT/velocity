require 'data_mapper'
require 'dm-timestamps'
require 'renee'
require 'sass/plugin/rack'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, {:adapter => 'sqlite3', :database => 'development.db'})

Dir['./app/models/**/*.rb'].each { |model| require model }

DataMapper.finalize
DataMapper.auto_upgrade!

