module ReadHelper
  def read_helper
    constant.where( uuid: params[ :uuid ] ).first
  end
end
