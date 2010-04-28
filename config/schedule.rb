every 12.hours do
  rake 'db2s3:backup:full'
end

every 1.week do
  rake 'db2s3:backup:clean'
end

