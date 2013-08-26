class FollowEvent < TimelineEvent

  def toString
    actor = self.actor.login
    target = self.targetActor.login
    "#{actor} started following #{target}"
  end

end