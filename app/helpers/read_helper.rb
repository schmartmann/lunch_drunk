module ReadHelper

  def read_helper
    existing_record =
      constant
        .where(
          uuid: params[ :uuid ]
        ).first
  end
end
