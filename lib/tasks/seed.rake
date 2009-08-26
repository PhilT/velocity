namespace :db do
  desc "Drop, create, migrate then seed development and test databases"
  task :seed => :environment do
    seed_for('development')
    seed_for('test')
  end
  
  def self.seed_for(env)
    ENV['RAILS_ENV'] = env
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task[env == 'test' ? 'db:test:prepare' : 'db:migrate'].invoke
    require 'active_record/fixtures'
    Dir.glob(RAILS_ROOT + '/db/fixtures/*.yml').each do |file|
      Fixtures.create_fixtures('db/fixtures', File.basename(file, '.*'))
    end
  end
end

