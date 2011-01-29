# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Velocity::Application.initialize!

S3FILE = S3File.new(S3_CONFIG) if defined?(S3)
