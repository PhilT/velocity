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
    populate('db/fixtures/static')
    populate('db/fixtures/example') if ENV['EXAMPLE']
  end

  def populate(sub_dir)
    Dir.glob(RAILS_ROOT + "/#{sub_dir}/*.yml").each do |file|
      Fixtures.create_fixtures(sub_dir, File.basename(file, '.*'))
    end
  end
end

