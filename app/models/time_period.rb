class TimePeriod < ActiveRecord::Base

  #----------------------------------------------------------------------------
  # attributes

  ATTRIBUTES = %i(
    name
  ).freeze


  #----------------------------------------------------------------------------
  # validations

  validates :name,
            presence: true

  #----------------------------------------------------------------------------
  # associations

  has_many  :meals, dependent: :destroy
end
