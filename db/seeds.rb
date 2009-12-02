

require 'active_record/fixtures'
seed_dir = 'db/seed_data'
Dir.glob("#{RAILS_ROOT}/#{seed_dir}/*.yml").each do |file|
  Fixtures.create_fixtures(seed_dir, File.basename(file, '.*'))
end


Release.create!

