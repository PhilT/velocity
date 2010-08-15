# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
end

Sass::Plugin.options[:template_location] = RAILS_ROOT + '/app/styles' if defined?(Sass)
STRAPLINE = "Simple Release Management"
RELEASE_CONFIRMATION_MESSAGE = 'Finish release and email features and bugs completed? This does not include incomplete tasks'
S3FILE = S3File.new(S3_CONFIG) if defined?(S3) && defined?(S3_CONFIG)

