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

  class << self

    def fetchProfileInfo
      buildHttpClient
      AFMotion::Client.shared.get("/users/#{self.login}") do |result|
        NotificationCenter.defaultCenter.postNotificationName('ProfileInfoFetched', object:self.new(result.object))
      end
    end

    def fetchInfoForUserWithToken(token)
      AFMotion::Client.shared.get("/user") do |result|
        if result.success?
          NotificationCenter.defaultCenter.postNotificationName('AuthenticatedUserFetched', object:self.new(result.object))
        else
        end
      end
    end

    def buildHttpClient
      @httpClient ||= AFMotion::Client.build_shared(GITHUB_API_HOST) do
        header "Accept", "application/json"
        authorization(username: username, password: password)
        parameter_encoding :json
        operation :json
      end
    end

  end

end