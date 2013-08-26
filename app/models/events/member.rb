class MemberEvent < TimelineEvent

  def toString
    "#{actor.login} added #{member.login} to #{repo.name}"
  end

  def member
    User.new(payload[:member])
  end

end