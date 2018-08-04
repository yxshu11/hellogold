class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :current_admin?

  def current_admin?
    if current_user.present?
      current_user.is_admin?
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :country_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :country_id])
  end
end
