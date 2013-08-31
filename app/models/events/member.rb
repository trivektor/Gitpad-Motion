class MemberEvent < TimelineEvent

  def toString
    "#{actor.login} added #{member.login} to #{repo.name}"
  end

  def toHtmlString
    actor = self.actor
    member = self.member
    repo = self.repo

    mainBundle = NSBundle.mainBundle

    actorHtml = NSString.stringWithContentsOfFile(
      mainBundle.pathForResource('html/event_actor', ofType: 'html'),
      encoding: NSASCIIStringEncoding,
      error: nil)

    targetActorHtml = NSString.stringWithContentsOfFile(
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

    toHtml = NSString.stringWithContentsOfFile(
      mainBundle.pathForResource('html/event_action', ofType: 'html'),
      encoding: NSASCIIStringEncoding,
      error: nil)

    actorHtml = actorHtml.stringByReplacingOccurrencesOfString('{{actor}}', withString: 'actor:')
                         .stringByReplacingOccurrencesOfString('{{avatar}}', withString: actor.avatarUrl)
                         .stringByReplacingOccurrencesOfString('{{login}}', withString: actor.login)

    actionHtml = actionHtml.stringByReplacingOccurrencesOfString('{{action}}', withString: 'added')
    toHtml = toHtml.stringByReplacingOccurrencesOfString('{{action}}', withString: 'to')

    targetActorHtml = targetActorHtml.stringByReplacingOccurrencesOfString('{{actor}}', withString: 'actor:')
                                     .stringByReplacingOccurrencesOfString('{{avatar}}', withString: member.avatarUrl)
                                     .stringByReplacingOccurrencesOfString('{{login}}', withString: member.login)

    repoHtml = repoHtml.stringByReplacingOccurrencesOfString('{{actor}}', withString: 'repo:')
                       .stringByReplacingOccurrencesOfString('{{avatar}}', withString: GITHUB_OCTOCAT)
                       .stringByReplacingOccurrencesOfString('{{login}}', withString: repo.name)

    array = NSArray.alloc.initWithArray([actorHtml, actionHtml, targetActorHtml, toHtml, repoHtml])
    array.componentsJoinedByString('')
  end

  def member
    User.new(payload[:member])
  end

end