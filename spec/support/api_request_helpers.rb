module ApiRequests
  module AuthenticationHelpers
    def request_as_user params={}
      _user_auth_headers
      do_request params
    end

  private

    def _user_auth_headers
       # header 'Content-Type', 'application/json'
       # header 'Accept', 'application/json'
       header 'Authorization', "Bearer #{_access_token}"
       header 'User-Agent', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/536.5 (KHTML, like Gecko) Chrome/19.0.1084.56 Safari/536.5'
       header 'X-API-Version', '0.0.1'
       # header 'X-API-Client', 'ExampleApp/TestSuite 0.0.1'
       # header 'X-API-Device', 'iPhone 5,1 (iOS 8.1.3)'
    end

    def _user
      raise '"user" variable in request tests is not defined' unless respond_to?(:user) || user.present?
      user
    end


    def _access_token
      @_access_token ||= create(:access_token, application: _client_application, resource_owner_id: _user.id).token
    end

    def _client_application
      @_client_application ||= try(:client_application) || create(:client_application)
    end
  end
end
