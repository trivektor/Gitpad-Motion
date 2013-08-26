class IssuesEvent < TimelineEvent

  def toString
    action = payload[:action]
    "#{actor.login} #{action} issue #{repo.name}##{issue.number}"
  end

  def issue
    Issue.new(payload[:issue])
  end

end