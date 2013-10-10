module User

  module Notification

    def fetchNotifications(page=1)
      buildHttpClient
      AFMotion::Client.shared.get('/notifications', page: page, access_token: AppHelper.getAccessToken, all: true) do |result|
        if result.success?
          notifications = result.object.collect { |o| ::Notification.new(o) }
          @notifications = groupNotificationsByRepo(notifications)
          'UserNotificationsFetched'.post_notification
        else
          puts result.error.localizedDescription
        end
      end
    end

    def resetNotifications
      @notifications.clear
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

  end

end