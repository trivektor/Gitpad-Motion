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

  def location
    @data[:location]
  end

  def website
    @data[:blog]
  end

  def email
    @data[:email]
  end

  def company
    @data[:company]
  end

  def following
    @data[:following].to_i
  end

  def followers
    @data[:followers].to_i
  end

  def numPublicRepos
    @data[:public_repos].to_i
  end

  def numPublicGists
    @data[:public_gists].to_i
  end

  def createdAt
    @data[:created_at]
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
    params = {
      :page => page,
      :access_token => AppHelper.getAccessToken,
      :private => true
    }
    AFMotion::Client.shared.get("/user/repos", params) do |result|
      if result.success?
        repos = result.object.collect { |r| Repo.new(r) }
        'ReposFetched'.post_notification(repos)
      else
        puts result.error.localizedDescription
      end
    end
  end

  def fetchStarredReposForPage(page=1)
    self.class.buildHttpClient
    AFMotion::Client.shared.get("/users/#{self.login}/starred", page: page, access_token: AppHelper.getAccessToken) do |result|
      if result.success?
        repos = result.object.collect { |r| Repo.new(r) }
        'ReposFetched'.post_notification(repos)
      else
        puts result.error.localizedDescription
      end
    end
  end

  def fetchPersonalGistsForPage(page=1)
    self.class.buildHttpClient
    AFMotion::Client.shared.get("/users/#{self.login}/gists", page: page, access_token: AppHelper.getAccessToken) do |result|
      if result.success?
        gists = result.object.collect { |r| Gist.new(r) }
        'GistsFetched'.post_notification(gists)
      else
        puts result.error.localizedDescription
      end
    end
  end

  def fetchProfileInfo
    self.class.buildHttpClient
    AFMotion::Client.shared.get("/users/#{self.login}") do |result|
      NSNotificationCenter.defaultCenter.postNotificationName('ProfileInfoFetched', object: self.class.new(result.object))
    end
  end

  class << self

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