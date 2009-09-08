require 'active_record/fixtures'
fixtures_dir = 'db/fixtures'
Dir.glob("#{RAILS_ROOT}/#{fixtures_dir}/*.yml").each do |file|
  Fixtures.create_fixtures(fixtures_dir, File.basename(file, '.*'))
end

