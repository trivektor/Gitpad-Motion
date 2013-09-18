class CommitFile

  attr_accessor :data

  def initialize(data={})
    @data = data
  end

  def sha
    @data[:sha]
  end

  def name
    @data[:filename]
  end

  def status
    @data[:status]
  end

  def additions
    @data[:additions]
  end

  def deletions
    @data[:deletions]
  end

  def changes
    @data[:changes]
  end

  def patch
    encodeHtmlEntities(@data[:patch] || '')
  end

  def totalChanges
    additions.to_i + deletions.to_i
  end

  def encodeHtmlEntities(rawHtmlString)
    rawHtmlString.stringByReplacingOccurrencesOfString('>', withString: '&#62;')
                 .stringByReplacingOccurrencesOfString('<', withString: '&#60;')
  end

end