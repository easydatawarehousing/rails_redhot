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

  spec.metadata["allowed_push_host"] = "https://rubygems.org/"
  spec.metadata["homepage_uri"]      = spec.homepage
  spec.metadata["source_code_uri"]   = "https://github.com/easydatawarehousing/rails_redhot"
  spec.metadata["changelog_uri"]     = "https://github.com/easydatawarehousing/rails_redhot/blob/master/CHANGELOG.md"

  spec.files = Dir["{lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md", "CHANGELOG.md"]

  spec.add_dependency "rails", "~> 7.0.0"
end
