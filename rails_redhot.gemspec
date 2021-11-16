require_relative "lib/rails_redhot/version"

Gem::Specification.new do |spec|
  spec.name        = "rails_redhot"
  spec.version     = RailsRedhot::VERSION
  spec.authors     = ["Ivo Herweijer"]
  spec.email       = ["info@edwhs.nl"]
  spec.homepage    = "https://github.com/easydatawarehousing/rails_redhot"
  spec.summary     = "REDux pattern for HOTwire == Redhot"
  spec.description = "REDux pattern for HOTwire == Redhot"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/easydatawarehousing/rails_redhot"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 7.0.0.alpha2"
end
