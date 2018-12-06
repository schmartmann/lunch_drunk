module ControllerHelper
  def constant
    params[ :controller ].capitalize.camelcase.singularize.constantize
  end
end
