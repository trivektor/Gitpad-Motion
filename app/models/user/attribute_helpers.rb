module User

  module AttributeHelplers

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
      @data[:blog] || 'n/a'
    end

    def email
      @data[:email] || 'n/a'
    end

    def company
      @data[:company] || 'n/a'
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

  end

end