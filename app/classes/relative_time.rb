module RelativeTime

  def relativeTime(originalDateTime)
    @dateFormatter ||= NSDateFormatter.alloc.init
    @dateFormatter.setDateFormat(DATE_TIME_FORMAT)
    date = @dateFormatter.dateFromString(originalDateTime)
    date.timeAgo
  end

  def relativeCreatedAt
    relativeTime(createdAt)
  end

  def relativeUpdatedAt
    relativeTime(updatedAt)
  end

end