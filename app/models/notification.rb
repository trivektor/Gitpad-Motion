class Notification

  include AFNetWorking

  attr_accessor :data, :repo

  def initialize(data={})
    @data = data
  end

  def repository
    @repo ||= Repo.new(@data[:repository])
  end

  def subject
    @data[:subject]
  end

  def title
    subject[:title]
  end

  def type
    subject[:type]
  end

  def unread?
    @data[:unread]
  end

  def updatedAt
    @data[:updated_at]
  end

  def lastReadAt
    @data[:last_read_at]
  end

  def read?
    !lastReadAt.nil?
  end

  def url
    subject[:url]
  end

  def fetch
    buildHttpClient
    AFMotion::Client.shared.get(url, access_token: AppHelper.getAccessToken) do |result|
      if result.success?
        object = Kernel.const_get(type).new(result.object)
        'NotificationDetailsFetched'.post_notification(object)
      else
        puts result.error.localizedDescription
      end
    end
  end

end