class ApplicationRecord < ActiveRecord::Base
  include RailsRedhot::ActsAsRedux

  primary_abstract_class
end
