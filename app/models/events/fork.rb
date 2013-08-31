class ForkEvent < TimelineEvent

  def toString
    toActorRepoString('forked')
  end

  def toHtmlString
    toActorRepoHtmlString('forked')
  end

end