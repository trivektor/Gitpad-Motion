class User

  include RelativeTime
  include AFNetWorking
  extend AFNetWorking

  attr_accessor :data, :notifications, :events, :activities, :followers, :following, :personal_repos, :starred_repos, :gists, :organizations

  def initialize(data={})
    @data = data
    @events = []
    @activities = []
    @notifications = {}
    @followers = []
    @following = []
    @personal_repos = []
    @starred_repos = []
    @gists = []
    @organizations = []
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

  def numFollowing
    @data[:following].to_i
  end

  def numFollowers
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

  def followersUrl
    @data[:followers_url]
  end

  def followingUrl
    @data[:following_url].gsub('{/other_user}', '')
  end

  def myself?
    self.login == CurrentUserManager.sharedInstance.login
  end

  def fetchNewsfeedForPage(page=1)
    buildHttpClient
    AFMotion::Client.shared.get("/users/#{login}/received_events", page: page, access_token: AppHelper.getAccessToken) do |result|
      if result.success?
        @events += result.object.collect { |e| Kernel::const_get(e[:type]).new(e) }
        'NewsFeedFetched'.post_notification
      else
        puts result.error.localizedDescription
      end
    end
  end

  def fetchActivitiesForPage(page=1)
    buildHttpClient
    AFMotion::Client.shared.get("/users/#{login}/events", page: page, access_token: AppHelper.getAccessToken) do |result|
      if result.success?
        @activities += result.object.collect { |e| Kernel::const_get(e[:type]).new(e) }
        'ActivitiesFetched'.post_notification
      else
        puts result.error.localizedDescription
      end
    end
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
        @personal_repos += result.object.collect { |r| Repo.new(r) }
        'ReposFetched'.post_notification
      else
        puts result.error.localizedDescription
      end
    end
  end

  def fetchStarredReposForPage(page=1)
    buildHttpClient
    AFMotion::Client.shared.get("/users/#{login}/starred", page: page, access_token: AppHelper.getAccessToken) do |result|
      if result.success?
        @starred_repos += result.object.collect { |r| Repo.new(r) }
        'ReposFetched'.post_notification
      else
        puts result.error.localizedDescription
      end
    end
  end

  def fetchPersonalGistsForPage(page=1)
    buildHttpClient
    AFMotion::Client.shared.get("/users/#{login}/gists", page: page, access_token: AppHelper.getAccessToken) do |result|
      if result.success?
        @gists += result.object.collect { |r| Gist.new(r) }
        'GistsFetched'.post_notification
      else
        puts result.error.localizedDescription
      end
    end
  end

  def fetchOrganizations
    buildHttpClient
    AFMotion::Client.shared.get("/users/#{login}/orgs", access_token: AppHelper.getAccessToken) do |result|
      if result.success?
        @organizations = result.object.collect { |o| Organization.new(o) }
        'OrganizationsFetched'.post_notification
      else
        puts result.error.localizedDescription
      end
    end
  end

  def fetchProfileInfo
    buildHttpClient
    AFMotion::Client.shared.get("/users/#{login}") do |result|
      @data = result.object
      'ProfileInfoFetched'.post_notification
    end
  end

  def fetchFollowers(page=1)
    buildHttpClient
    AFMotion::Client.shared.get(followersUrl, page: page, access_token: AppHelper.getAccessToken) do |result|
      if result.success?
        @followers += result.object.collect { |u| User.new(u) }
        'FollowUsersFetched'.post_notification
      else
        puts result.error.localizedDescription
      end
    end
  end

  def fetchFollowing(page=1)
    buildHttpClient
    AFMotion::Client.shared.get(followingUrl, page: page, access_token: AppHelper.getAccessToken) do |result|
      if result.success?
        @following += result.object.collect { |u| User.new(u) }
        'FollowUsersFetched'.post_notification
      else
        puts result.error.localizedDescription
      end
    end
  end

  def checkFollowing(user)
    buildHttpClient
    AFMotion::Client.shared.get("/user/following/#{user.login}", access_token: AppHelper.getAccessToken) do |result|
      'FollowingChecked'.post_notification(result.operation)
    end
  end

  def follow(user)
    buildHttpClient
    AFMotion::Client.shared.put("/user/following/#{user.login}", access_token: AppHelper.getAccessToken) do |result|
      'UserFollowChanged'.post_notification(204)
    end
  end

  def unfollow(user)
    buildHttpClient
    AFMotion::Client.shared.delete("/user/following/#{user.login}", access_token: AppHelper.getAccessToken) do |result|
      'UserFollowChanged'.post_notification(404)
    end
  end

  def fetchNotifications(page=1)
    buildHttpClient
    AFMotion::Client.shared.get('/notifications', page: page, access_token: AppHelper.getAccessToken, all: true) do |result|
      if result.success?
        notifications = result.object.collect { |o| Notification.new(o) }
        @notifications = groupNotificationsByRepo(notifications)
        'UserNotificationsFetched'.post_notification
      else
        puts result.error.localizedDescription
      end
    end
  end

  def groupNotificationsByRepo(notifications)
    {}.tap do |groups|
      notifications.each do |notification|
        repoName = notification.repository.fullName
        groups[repoName] = [notification] unless groups.key?(repoName)
        groups[repoName] << notification
      end
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