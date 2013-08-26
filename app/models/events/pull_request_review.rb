class PullRequestReviewEvent < TimelineEvent

  def toString
    payload = self.payload
    "#{actor.login} commented on pull request #{repo.name}/#{payload[:number]}"
  end

end