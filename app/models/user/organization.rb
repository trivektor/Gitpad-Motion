module User

  module Organization

    def resetOrganizations
      @organizations.clear
    end

    def fetchOrganizations
      buildHttpClient
      AFMotion::Client.shared.get("/users/#{login}/orgs", access_token: AppHelper.getAccessToken) do |result|
        if result.success?
          @organizations = result.object.collect { |o| ::Organization.new(o) }
          'OrganizationsFetched'.post_notification
        else
          puts result.error.localizedDescription
        end
      end
    end

  end

end