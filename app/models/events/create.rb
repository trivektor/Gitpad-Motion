module Events
  class Create < TimelineEvent

    def toString
      toActorRepoString('created')
    end

  end
end