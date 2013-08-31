class GollumEvent < TimelineEvent

  def toString
    toActorRepoString('created wiki for')
  end

  def toHtmlString
    toActorRepoHtmlString('created wiki for')
  end

end