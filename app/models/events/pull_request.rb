class PullRequestEvent < TimelineEvent

  def toString
    action = payload[:action]
    "#{actor.login} #{action} pull request #{repo.name}##{payload[:number]}"
  end

end