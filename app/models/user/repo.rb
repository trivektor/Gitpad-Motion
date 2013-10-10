module User

  module Repo

    def resetPersonalRepos
      @personal_repos.clear
    end

    def fetchPersonalReposForPage(page=1)
      buildHttpClient
      params = {
        :page => page,
        :access_token => AppHelper.getAccessToken,
        :private => true
      }
      AFMotion::Client.shared.get("/user/repos", params) do |result|
        if result.success?
          @personal_repos += result.object.collect { |r| ::Repo.new(r) }
          'ReposFetched'.post_notification
        else
          puts result.error.localizedDescription
        end
      end
    end

    def resetStarredRepos
      @starred_repos.clear
    end

    def fetchStarredReposForPage(page=1)
      buildHttpClient
      AFMotion::Client.shared.get("/users/#{login}/starred", page: page, access_token: AppHelper.getAccessToken) do |result|
        if result.success?
          @starred_repos += result.object.collect { |r| ::Repo.new(r) }
          'ReposFetched'.post_notification
        else
          puts result.error.localizedDescription
        end
      end
    end

  end

end