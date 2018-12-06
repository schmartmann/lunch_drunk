class TimePeriod < ActiveRecord::Base
  include UUID

  #----------------------------------------------------------------------------
  # attributes

  ATTRIBUTES = %i(
    uuid
    name
  ).freeze


  #----------------------------------------------------------------------------
  # validations

  validates :name,
            presence: true,
            uniqueness: { case_sensitive: false },
            allow_blank: false

  #----------------------------------------------------------------------------
  # associations

  has_many  :meals, dependent: :destroy
end
