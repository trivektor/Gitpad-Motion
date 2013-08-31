class Repo

  attr_accessor :data

  def initialize(data={})
    @data = data
  end

  def name
    @data[:name]
  end

  def full_name
    # TO BE IMPLEMENTED
  end

  def forks
    @data[:forks].to_i
  end

  def watchers
    @data[:watchers].to_i
  end

  def language
    @data[:language]
  end

  def size
    @data[:size]
  end

  def url
    @data[:url]
  end

  def pushed_at
    @data[:pushed_at]
  end

  def created_at
    @data[:created_at]
  end

  def updated_at
    @data[:updated_at]
  end

  def description
    @data[:description]
  end

  def home_page
    @data[:homepage]
  end

  def open_issues
    @data[:open_issues].to_i
  end

  def has_issues
    @data[:has_issues]
  end

  def owner
    @data[:owner]
  end

end