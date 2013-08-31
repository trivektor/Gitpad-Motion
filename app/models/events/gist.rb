class GistEvent < TimelineEvent

  def toString
    actor = self.actor.login
    gist = self.gist.id
    action = self.payload[:action]
    "#{actor} #{action} gist:#{gist}"
  end

  def toHtmlString
    payload = self.payload
    actor = self.actor
    gist = self.gist

    mainBundle = NSBundle.mainBundle

    actorHtml = NSString.stringWithContentsOfFile(
      mainBundle.pathForResource('html/event_actor', ofType: 'html'),
      encoding: NSASCIIStringEncoding,
      error: nil)

    gistHtml = NSString.stringWithContentsOfFile(
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

    gistHtml = gistHtml.stringByReplacingOccurrencesOfString('{{actor}}', withString: 'gist:')
                       .stringByReplacingOccurrencesOfString('{{avatar}}', withString: GITHUB_OCTOCAT)
                       .stringByReplacingOccurrencesOfString('{{login}}', withString: "gist:#{gist.id}")

    actionHtml = actionHtml.stringByReplacingOccurrencesOfString('{{action}}', withString: payload[:action])

    array = NSArray.alloc.initWithArray([actorHtml, actionHtml, gistHtml])
    array.componentsJoinedByString('')
  end

  def gist
    Gist.new(self.payload[:gist])
  end

end