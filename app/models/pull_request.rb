class PullRequest

  include AFNetWorking

  attr_accessor :data, :repo, :owner

  def initialize(data={})
    @data = data
  end

  def repo
    @repo ||= Repo.new(@data[:repository])
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
    @owner ||= User.new(@data[:user])
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

  def fetchComments
    buildHttpClient
    AFMotion::Client.shared.get(commentsUrl, access_token: AppHelper.getAccessToken) do |result|
      if result.success?
        @comments = result.object.collect { |o| Comment.new(o) }
        'PullRequestCommentsFetch'.post_notification
      else
        puts result.error.localizedDescription
      end
    end
  end

end