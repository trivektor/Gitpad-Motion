module Events
  class Fork < TimelineEvent

    def toString
      toActorRepoString('forked')
    end

  end
end