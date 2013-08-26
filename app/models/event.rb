class TimelineEvent

  attr_accessor :data

  ICONS = {
    forkevent: 'icon-code-fork',
    watchevent: 'icon-star',
    createevent: 'icon-keyboard',
    followevent: 'icon-user',
    gistevent: 'icon-code',
    issuesevent: 'icon-warning-sign',
    memberevent: 'icon-plus',
    issuecommentevent: 'icon-comment',
    pushevent: 'icon-upload',
    pulleequestevent: 'icon-retweet',
    publicevent: 'icon-folder-open',
    commitcommentevent: 'icon-comments',
    gollumnevent: 'icon-book'
  }

  def initialize(data={})
    @data = data
  end

  def id
    @data[:id]
  end

  def payload
    @data[:payload]
  end

  def target
    payload[:target]
  end

  def type
    @data[:type]
  end

  def actor
    User.new(@data[:actor])
  end

  def targetActor
    User.new(target)
  end

  def member
    User.new(payload[:member])
  end

  def targetGist
    # TO BE IMPLEMENTED
  end

  def repo
    Repo.new(@data[:repo])
  end

  def toActorRepoString(actionName)
    actor = self.actor.login
    repo = self.repo.name
    "#{actor} #{actionName} #{repo}"
  end

  def icon(type)
    ICONS[type.downcase.to_sym]
  end

  def toString
    ''
  end

  def createdAt
    @data[:created_at]
  end

  def updatedAt
    @data[:updated_at]
  end

end

