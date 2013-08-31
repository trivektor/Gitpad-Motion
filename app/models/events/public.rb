class PublicEvent < TimelineEvent

  def toString
    toActorRepoString('open sourced')
  end

  def toHtmlString
    toActorRepoHtmlString('open sourced')
  end

end