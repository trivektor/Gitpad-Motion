class GollumEvent < TimelineEvent

  def toString
    toActorRepoString('created wiki for')
  end

end