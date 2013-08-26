class GistEvent < TimelineEvent

  def toString
    actor = self.actor.login
    gist = self.gist.id
    action = self.payload[:action]
    "#{actor} #{action} gist:#{gist}"
  end

  def gist
    Gist.new(self.payload[:gist])
  end

end