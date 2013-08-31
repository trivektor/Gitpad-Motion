class PushEvent < TimelineEvent

  def toString
    "#{actor.login} pushed to #{repo.name} at #{ref.last}"
  end

  def toHtmlString
    payload = self.payload
    actor = self.actor
    repo = self.repo
    ref = self.ref

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

    refHtml = NSString.stringWithContentsOfFile(
      mainBundle.pathForResource('html/event_actor', ofType: 'html'),
      encoding: NSASCIIStringEncoding,
      error: nil)

    atHtml = NSString.stringWithContentsOfFile(
      mainBundle.pathForResource('html/event_action', ofType: 'html'),
      encoding: NSASCIIStringEncoding,
      error: nil)

    actorHtml = actorHtml.stringByReplacingOccurrencesOfString('{{actor}}', withString: 'actor:')
                         .stringByReplacingOccurrencesOfString('{{avatar}}', withString: actor.avatarUrl)
                         .stringByReplacingOccurrencesOfString('{{login}}', withString: actor.login)

    actionHtml = actionHtml.stringByReplacingOccurrencesOfString('{{action}}', withString: 'pushed to')
    atHtml = atHtml.stringByReplacingOccurrencesOfString('{{action}}', withString: 'at')

    refHtml = refHtml.stringByReplacingOccurrencesOfString('{{actor}}', withString: 'repo:')
                     .stringByReplacingOccurrencesOfString('{{avatar}}', withString: GITHUB_OCTOCAT)
                     .stringByReplacingOccurrencesOfString('{{login}}', withString: ref)

    array = NSArray.alloc.initWithArray([actorHtml, actionHtml, repoHtml, atHtml, refHtml])
    array.componentsJoinedByString('')
  end

  def ref
    self.payload[:ref].to_s.split('/')
  end

end