# Set up gems listed in the Gemfile.
ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../../../Gemfile", __dir__)

# :nocov:
require "bundler/setup" if File.exist?(ENV["BUNDLE_GEMFILE"])
# :nocov:
$LOAD_PATH.unshift File.expand_path("../../../lib", __dir__)
