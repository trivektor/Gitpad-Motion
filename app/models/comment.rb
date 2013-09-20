class Comment

  include RelativeTime

  attr_accessor :data, :user

  def initialize(data={})
    @data = data
  end

  def user
    @user ||= User.new(@data[:user])
  end

  def body
    @data[:body]
  end

  def createdAt
    @data[:created_at]
  end

  def updatedAt
    @data[:updated_at]
  end

  def toHtmlString
    "<tr>
      <td>
        <img src='#{user.avatarUrl}' class='avatar pull-left' />
          <div class='comment-details'>
            <b>#{user.login}</b>
            <span class='lightgrey'>commented #{createdAt}</span>
            <p>#{encodeHtmlEntities(body)}</p>
          </div>
      </td>
    </tr>"
  end

  def encodeHtmlEntities(rawString)
    rawString.stringByReplacingOccurrencesOfString('>', withString: '&#62;')
             .stringByReplacingOccurrencesOfString('<', withString: '&#60;')
  end

end