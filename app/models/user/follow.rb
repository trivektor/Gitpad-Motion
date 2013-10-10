module User

  module Follow

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

    def resetFollowers
      @followers.clear
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

    def resetFollowing
      @following.clear
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

  end
end