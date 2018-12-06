class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include NotFoundError

  include ControllerHelper
  include QueryHelper
  include ReadHelper
end
