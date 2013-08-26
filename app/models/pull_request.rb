class PullRequest

  attr_accessor :data

  def initialize(data={})
    @data = data
  end

  def repo
    Repo.new(@data[:repository])
  end

  def subject
    @data[:subject]
  end

  def title
    @data[:title]
  end

  def commentsUrl
    @data[:comments_url]
  end

  def owner
    User.new(@data[:user])
  end

  def state
    @data[:state]
  end

  def body
    @data[:body]
  end

  def closedAt
    @data[:closed_at]
  end

end