class IssueCommentEvent < TimelineEvent

  def toString
    "#{actor.login} commented on issue #{repo.name}##{issue.number}"
  end

  def issue
    Issue.new(payload[:issue])
  end

end