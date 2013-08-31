class TimelineEvent

  attr_accessor :data

  ICONS = {
    forkevent: 'code-fork',
    watchevent: 'star',
    createevent: 'keyboard',
    followevent: 'user',
    gistevent: 'code',
    issuesevent: 'warning-sign',
    memberevent: 'plus',
    issuecommentevent: 'comment',
    pushevent: 'upload',
    pulleequestevent: 'retweet',
    publicevent: 'folder-open',
    commitcommentevent: 'comments',
    gollumnevent: 'book'
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

  def icon
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

  def toActorRepoHtmlString(actionName)
    mainBundle = NSBundle.mainBundle

    actorHtml = NSString.stringWithContentsOfFile(
      mainBundle.pathForResource('html/event_actor', ofType: 'html'),
      encoding: NSASCIIStringEncoding,
      error: nil)

    repoHtml = NSString.stringWithContentsOfFile(
      mainBundle.pathForResource('html/event_actor', ofType: 'html'),
      encoding: NSASCIIStringEncoding,
      error: nil)

    actionHtml = NSString.stringWithContentsOfFile(
      mainBundle.pathForResource('html/event_action', ofType: 'html'),
      encoding: NSASCIIStringEncoding,
      error: nil)

    actor = self.actor
    actorHtml = actorHtml.stringByReplacingOccurrencesOfString('{{actor}}', withString: 'actor:')
                         .stringByReplacingOccurrencesOfString('{{avatar}}', withString: actor.avatarUrl)
                         .stringByReplacingOccurrencesOfString('{{login}}', withString: actor.login)

    repoHtml = repoHtml.stringByReplacingOccurrencesOfString('{{actor}}', withString: 'actor:')
                       .stringByReplacingOccurrencesOfString('{{avatar}}', withString: GITHUB_OCTOCAT)
                       .stringByReplacingOccurrencesOfString('{{login}}', withString: repo.name)

    actionHtml = actionHtml.stringByReplacingOccurrencesOfString('{{action}}', withString: actionName)

    array = NSArray.alloc.initWithArray([actorHtml, actionHtml, repoHtml])
    array.componentsJoinedByString('')
  end

  def toHtmlString
    ''
  end

end

