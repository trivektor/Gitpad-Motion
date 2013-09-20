module RelativeTime

  def relativeTime(originalDateTime)
    @dateFormatter ||= NSDateFormatter.alloc.init
    @dateFormatter.setDateFormat(DATE_TIME_FORMAT)
    @dateDescriptor ||= RelativeDateDescriptor.alloc.initWithPriorDateDescriptionFormat('%@ ago', postDateDescriptionFormat: 'in %@')
    date = @dateFormatter.dateFromString(originalDateTime.to_s)
    # date.timeAgo
    @dateDescriptor.describeDate(date, relativeTo: NSDate.date)
  end

  def relativeCreatedAt
    relativeTime(createdAt).downcase
  end

  def relativeUpdatedAt
    relativeTime(updatedAt).downcase
  end

end