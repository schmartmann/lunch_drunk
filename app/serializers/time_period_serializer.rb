class TimePeriodSerializer < ActiveModel::Serializer
  has_many :meals

  attributes :id, :uuid, :name, :emoji
end
