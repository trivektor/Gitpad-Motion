class DeleteEvent < TimelineEvent

  def toString
    payload = self.payload
    "#{actor.login} deleted #{payload[:ref_type]} #{payload[:ref]}"
  end

end
