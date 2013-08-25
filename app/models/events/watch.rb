class WatchEvent < TimelineEvent

  def toString
    toActorRepoString('watched')
  end

end