module User

  module Newsfeed

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

    def resetActivities
      @activities.clear
    end

  end

end