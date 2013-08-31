class CreateEvent < TimelineEvent

  def toString
    toActorRepoString('created')
  end

  def toHtmlString
    toActorRepoHtmlString('created')
  end

end
