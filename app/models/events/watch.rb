class WatchEvent < TimelineEvent

  def toString
    toActorRepoString('watched')
  end

  def toHtmlString
    toActorRepoHtmlString('watched')
  end

end