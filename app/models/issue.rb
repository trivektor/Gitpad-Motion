class Issue

  include AFNetWorking

  attr_accessor :data, :comments, :user

  def initialize(data={})
    @data = data
    @comments = []
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
    @user ||= User.new(@data[:user])
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

  def createdAt
    @data[:created_at]
  end

  def fetchComments
    buildHttpClient
    AFMotion::Client.shared.get(commentsUrl, access_token: AppHelper.getAccessToken) do |result|
      if result.success?
        @comments = result.object.collect { |o| Comment.new(o) }
        'IssueCommentsFetch'.post_notification
      else
        puts result.error.localizedDescription
      end
    end
  end

  def commentsHtmlString
    @comments.collect { |comment| comment.toHtmlString }.join('')
  end

end