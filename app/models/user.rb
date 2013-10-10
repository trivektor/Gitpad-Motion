class User

  include RelativeTime
  include AFNetWorking
  extend AFNetWorking

  include User::AttributeHelplers
  include User::Newsfeed
  include User::Repo
  include User::Gist
  include User::Organization
  include User::Follow
  include User::Notification

  attr_accessor :data, :notifications, :events, :activities, :followers, :following,
                :personal_repos, :starred_repos, :gists, :organizations

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

  def fetchProfileInfo
    buildHttpClient
    AFMotion::Client.shared.get("/users/#{login}") do |result|
      @data = result.object
      'ProfileInfoFetched'.post_notification
    end
  end

  def updateProfile(data={})
    buildHttpClient
    AFMotion::Client.shared.patch("/user?access_token=#{AppHelper.getAccessToken}", data) do |result|
      if result.success?
        'ProfileUpdated'.post_notification
      else
        puts result.error.localizedDescription
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