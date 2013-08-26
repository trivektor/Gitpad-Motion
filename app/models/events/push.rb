class PushEvent < TimelineEvent

  def toString
    payload = self.payload
    ref = payload[:ref].to_s.split('/')
    "#{actor.login} pushed to #{repo.name} at #{ref.last}"
  end

end