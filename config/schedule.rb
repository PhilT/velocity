every 3.minutes do
  command 'source /home/ubuntu/.bashrc'
  rake 'db2s3:backup:full'
end

