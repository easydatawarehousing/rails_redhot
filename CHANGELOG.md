# 0.3.0 - November 26, 2024

- Make gem compatible with current Rails 7 and 8 versions

# 0.2.0 - March 14, 2023

- Demo application: Use Ruby 3.2.0, Rails 7.0.4.2
- Added simplecov and improve testcoverage
- Added reducer errors (ActiveModel::Errors), separate from the models own error object
- Use deep_dup before dispatching an action to make sure the original action is never
  modified by reducer methods. Use deep_symbolize_keys on an action for convenience
- Added after_change callback

# 0.1.1 - April 14, 2022

- Fix calling flatten! multiple times erased initial state
- Documentation updates
- Demo application: Use Ruby 3.1.2, Rails 7.0.2

# 0.1.0 - December 30, 2021

- Documentation updates
- Use Rails 7.0.0

# 0.0.2 - December 10, 2021

- Added testset
- Polished demo application

# 0.0.1 - November 16, 2021

- Initial release, not published to rubygems
