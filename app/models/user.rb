class User

  def initialize(data={})
    @data = data
  end

  def avatarUrl
    @data[:avatar_url]
  end

  def gravatarId
    @data[:gravatar_id]
  end

  def gistUrl
    @data[:gist_url]
  end

  def name
    @data[:name]
  end

  def login
    @data[:login]
  end

  def fetchNewsfeedForPage(page=1)
    self.class.buildHttpClient
    AFMotion::Client.shared.get("/users/#{self.login}/received_events", page: page, access_token: AppHelper.getAccessToken) do |result|
      if result.success?
        events = result.object.collect { |e| Kernel::const_get(e[:type]).new(e) }
        NSNotificationCenter.defaultCenter.postNotificationName('NewsFeedFetched', object: events)
      else
        puts result.error.localizedDescription
      end
    end
  end

  def fetchPersonalReposForPage(page=1)
    self.class.buildHttpClient
    AFMotion::Client.shared.get("/users/#{self.login}/repos", page: page, access_token: AppHelper.getAccessToken) do |result|
      if result.success?
        repos = result.object.collect { |r| Repo.new(r) }
        'ReposFetched'.post_notification(repos)
      else
        puts result.error.localizedDescription
      end
    end
  end

  class << self

    def fetchProfileInfo
      buildHttpClient
      AFMotion::Client.shared.get("/users/#{self.login}") do |result|
        NSNotificationCenter.defaultCenter.postNotificationName('ProfileInfoFetched', object:self.new(result.object))
      end
    end

    def fetchInfoForUserWithToken(token)
      buildHttpClient
      AFMotion::Client.shared.get("/user", access_token: token) do |result|
        if result.success?
          NSNotificationCenter.defaultCenter.postNotificationName('AuthenticatedUserFetched', object:self.new(result.object))
        else
          puts result.error.localizedDescription
        end
      end
    end

    def buildHttpClient
      @@httpClient ||= AFMotion::Client.build_shared(GITHUB_API_HOST) do
        header "Accept", "application/json"
        parameter_encoding :json
        operation :json
      end
    end

  end

end