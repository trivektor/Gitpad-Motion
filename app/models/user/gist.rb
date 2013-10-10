module User

  module Gist

    def resetGists
      @gists.clear
    end

    def fetchPersonalGistsForPage(page=1)
      buildHttpClient
      AFMotion::Client.shared.get("/users/#{login}/gists", page: page, access_token: AppHelper.getAccessToken) do |result|
        if result.success?
          @gists += result.object.collect { |r| ::Gist.new(r) }
          'GistsFetched'.post_notification
        else
          puts result.error.localizedDescription
        end
      end
    end

  end

end