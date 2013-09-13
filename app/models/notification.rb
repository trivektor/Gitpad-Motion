class Notification

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

end