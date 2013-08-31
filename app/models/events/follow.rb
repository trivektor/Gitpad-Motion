class FollowEvent < TimelineEvent

  def toString
    actor = self.actor.login
    target = self.targetActor.login
    "#{actor} started following #{target}"
  end

  def toHtmlString
    actor = self.actor
    targetActor = self.targetActor

    mainBundle = NSBundle.mainBundle

    actorHtml = NSString.stringWithContentsOfFile(
      mainBundle.pathForResource('html/event_actor', ofType: 'html'),
      encoding: NSASCIIStringEncoding,
      error: nil)

    targetActorHtml = NSString.stringWithContentsOfFile(
      mainBundle.pathForResource('html/event_actor', ofType: 'html'),
      encoding: NSASCIIStringEncoding,
      error: nil)

    actionHtml = NSString.stringWithContentsOfFile(
      mainBundle.pathForResource('html/event_action', ofType: 'html'),
      encoding: NSASCIIStringEncoding,
      error: nil)

    actorHtml = actorHtml.stringByReplacingOccurrencesOfString('{{actor}}', withString: 'actor:')
             .stringByReplacingOccurrencesOfString('{{avatar}}', withString: actor.avatarUrl)
             .stringByReplacingOccurrencesOfString('{{login}}', withString: actor.login)

    targetActorHtml = targetActorHtml.stringByReplacingOccurrencesOfString('{{actor}}', withString: 'actor:')
                   .stringByReplacingOccurrencesOfString('{{avatar}}', withString: targetActor.avatarUrl)
                   .stringByReplacingOccurrencesOfString('{{login}}', withString: targetActor.login)

    actionHtml = actionHtml.stringByReplacingOccurrencesOfString('{{action}}', withString: 'started following')

    array = NSArray.alloc.initWithArray([actorHtml, actionHtml, targetActorHtml])
    array.componentsJoinedByString('')
  end

  private

  def toHTMLStringForObject1WithName(name1, AndAvatar1: avatar1, Object2: name2, AndAvatar2: avatar2, AndAction: actionName)
    actorHtml = NSString.stringWithContentsOfFile(
      mainBundle.pathForResource('html/event_actor', ofType: 'html'),
      encoding: NSASCIIStringEncoding,
      error: nil)

    actionHtml = NSString.stringWithContentsOfFile(
      mainBundle.pathForResource('html/event_action', ofType: 'html'),
      encoding: NSASCIIStringEncoding,
      error: nil)

  end

end