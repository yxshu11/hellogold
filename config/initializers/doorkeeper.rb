require 'custom_token_response'
require 'custom_token_error_response'

Doorkeeper.configure do
  orm :active_record

  resource_owner_authenticator do
    current_user || warden.authenticate!(:scope => :user)
  end

  resource_owner_from_credentials do |routes|
    user = User.find_for_database_authentication(:email => params[:email])
    if user && user.valid_for_authentication? { user.valid_password?(params[:password]) }
      user
    end
  end

  access_token_expires_in 5.days

  grant_flows %w(password)

  skip_authorization do
    true
  end

end

Doorkeeper::OAuth::TokenResponse.send :prepend, CustomTokenResponse
Doorkeeper::OAuth::ErrorResponse.send :prepend, CustomTokenErrorResponse
