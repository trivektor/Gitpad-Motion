class Organization

  attr_accessor :data

  def initialize(data={})
    @data = data
  end

  def login
    @data[:login]
  end

  def url
    @data[:url]
  end

  def avatarUrl
    @data[:avatar_url]
  end

end