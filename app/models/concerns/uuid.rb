module UUID

  extend ActiveSupport::Concern

  included do

    validates           :uuid,
                        :presence => true,
                        :uniqueness => true,
                        :length => { is: 32 }

    after_initialize    :set_uuid,
                        on: :create

  end

  private

  def set_uuid
    self.uuid = SecureRandom.hex if self.uuid.blank?
  end

end
