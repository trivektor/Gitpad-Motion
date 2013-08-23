class AppHelper

  class << self

    def getAccessToken
      SSKeychain.passwordForService('access_token', account:APP_KEYCHAIN_ACCOUNT)
    end

    def getAccountUsername
      SSKeychain.passwordForService('username', account:APP_KEYCHAIN_ACCOUNT)
    end

    def flashAlert(message, inView:view)
      # TO BE IMPLEMENTED
    end

    def flashError(message, inView:view)
      # TO BE IMPLEMENTED
    end

  end

end