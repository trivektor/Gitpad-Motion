module Events
  class Watch < TimelineEvent

    def toString
      toActorRepoString('watched')
    end

  end
end