namespace :db do
  desc "Drop, create, migrate then seed"
  task :seed => :environment do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task[RAILS_ENV == 'test' ? 'db:test:prepare' : 'db:migrate'].invoke
    require 'active_record/fixtures'
    populate('db/fixtures/static')
    populate('db/fixtures/example') if ENV['EXAMPLE']
  end

  namespace :seed do
    task :user => :environment do
      User.create!(:name => 'Dev Guy', :email => 'dev@example.com', :password => 'password', :password_confirmation => 'password', :access_level => EnumValue.find_by_name('developer'))
    end
  end

  def populate(sub_dir)
    Dir.glob(RAILS_ROOT + "/#{sub_dir}/*.yml").each do |file|
      Fixtures.create_fixtures(sub_dir, File.basename(file, '.*'))
    end
  end
end

