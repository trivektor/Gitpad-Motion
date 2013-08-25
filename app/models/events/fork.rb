class ForkEvent < TimelineEvent

  def toString
    toActorRepoString('forked')
  end

end