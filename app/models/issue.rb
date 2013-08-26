class Issue

  attr_accessor :data
  
  def initialize(data={})
    @data = data
  end

  def labelsUrl
    @data[:labels_url]
  end

  def commentsUrl
    @data[:comments_url]
  end

  def htmlUrl
    @data[:html_url]
  end

  def number
    @data[:number].to_i
  end

  def title
    @data[:title]
  end

  def user
    User.new(@data[:user])
  end

  def state
    @data[:state]
  end

  def assignee
    User.new(@data[:assignee])
  end

  def body
    @data[:body]
  end

  def numComments
    @data[:comments].to_i
  end

  def closedAt
    Time.parse(@data[:closed_at])
  end

end