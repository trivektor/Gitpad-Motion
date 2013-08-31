class IssueCommentEvent < TimelineEvent

  def toString
    "#{actor.login} commented on issue #{repo.name}##{issue.number}"
  end

  def issue
    Issue.new(payload[:issue])
  end

  def toHtmlString
    actor = self.actor
    payload = self.payload
    repo = self.repo
    issue = self.issue

    mainBundle = NSBundle.mainBundle

    actorHtml = NSString.stringWithContentsOfFile(
      mainBundle.pathForResource('html/event_actor', ofType: 'html'),
      encoding: NSASCIIStringEncoding,
      error: nil)

    actorHtml = actorHtml.stringByReplacingOccurrencesOfString('{{actor}}', withString: 'actor:')
                         .stringByReplacingOccurrencesOfString('{{avatar}}', withString: actor.avatarUrl)
                         .stringByReplacingOccurrencesOfString('{{login}}', withString: actor.login)

    issueHtml = NSString.stringWithContentsOfFile(
      mainBundle.pathForResource('html/event_actor', ofType: 'html'),
      encoding: NSASCIIStringEncoding,
      error: nil)

    issueHtml = issueHtml.stringByReplacingOccurrencesOfString('{{actor}}', withString: 'issue:')
                         .stringByReplacingOccurrencesOfString('{{avatar}}', withString: "#{repo.name}##{issue.number}")
                         .stringByReplacingOccurrencesOfString('{{login}}', withString: actor.login)

    actionHtml = actionHtml.stringByReplacingOccurrencesOfString('{{action}}', withString: 'commented on issue')

    array = NSArray.alloc.initWithArray([actorHtml, actionHtml, issueHtml])
    array.componentsJoinedByString('')
  end

end