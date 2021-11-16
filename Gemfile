source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in redhot.gemspec.
gemspec

group :development do
  # Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
  gem "importmap-rails", ">= 0.3.4"

  # Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
  gem "turbo-rails", ">= 0.7.11"

  # Use Tailwind CSS [https://github.com/rails/tailwindcss-rails]
  gem "tailwindcss-rails", ">= 0.4.3"
end

# Your gem is dependent on dev or edge Rails. Once you can lock this
# dependency down to a specific version, move it to your gemspec.

# Use specific branch of Rails
gem "rails", "~> 7.0.0.alpha2"

# Use sqlite3 as the database for Active Record
gem "sqlite3", "~> 1.4"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"
# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"
# Start debugger with binding.b -- Read more: https://github.com/ruby/debug
# gem "debug", ">= 1.0.0", group: %i[ development test ]
