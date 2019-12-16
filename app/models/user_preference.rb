class UserPreference < ApplicationRecord
  belongs_to :user
  validates_numericality_of :cook_for_max, greater_than_or_equal_to: proc { |user_preference| user_preference.cook_for_min }
end
