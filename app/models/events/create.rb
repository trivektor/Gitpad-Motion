class CreateEvent < TimelineEvent

  def toString
    toActorRepoString('created')
  end

end
