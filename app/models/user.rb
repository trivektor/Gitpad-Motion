class User
  
  def initialize(data={})
    @data = data
  end
  
  def avatarUrl
    @data[:avatar_url]
  end
  
  def gravatarId
    @data[:gravatar_id]
  end
  
  def gistUrl
    @data[:gist_url]
  end
  
  def name
    @data[:name]
  end
  
end