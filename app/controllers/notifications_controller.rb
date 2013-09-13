class NotificationCell < UITableViewCell

  ICONS = {
    'Issue' => {icon: 'exclamation-sign', color: '#489d00'.uicolor},
    'PullRequest' => {icon: 'reply', color: '#9e157c'.uicolor}
  }

  attr_accessor :notification

  def initWithStyle(style, reuseIdentifier:identifier)
    super
    createLabels
    self
  end

  def createLabels
    @fontAwesomeLabel = UILabel.alloc.initWithFrame([[10, 11], [30, 21]])
    @fontAwesomeLabel.font = FontAwesome.fontWithSize(15)
    @fontAwesomeLabel.backgroundColor = UIColor.clearColor

    @titleLabel = UILabel.alloc.initWithFrame([[49, 11], [950, 21]])
    @titleLabel.font = UIFont.fontWithName('Roboto-Bold', size: 15)
    @titleLabel.backgroundColor = UIColor.clearColor

    @dateLabel = UILabel.alloc.initWithFrame([[49, 32], [950, 21]])
    @dateLabel.font = UIFont.fontWithName('Roboto-Light', size: 15)
    @dateLabel.backgroundColor = UIColor.clearColor

    self.contentView.addSubview(@fontAwesomeLabel)
    self.contentView.addSubview(@titleLabel)
    self.contentView.addSubview(@dateLabel)
  end

  def render
    @titleLabel.text = @notification.title
    @dateLabel.text = @notification.updatedAt

    self.contentView.backgroundColor = notification.read? ? '#eee'.uicolor : UIColor.whiteColor
    @fontAwesomeLabel.text = FontAwesome.icon(ICONS[notification.type][:icon])
    @fontAwesomeLabel.textColor = ICONS[notification.type][:color]
  end

end

class NotificationsController < UIViewController

  attr_accessor :user

  def viewDidLoad
    super
    performHousekeepingTasks
    registerEvents
    @user.fetchNotifications
  end

  def performHousekeepingTasks
    self.navigationItem.title = 'Notifications'
    @table = createTable(cell: NotificationCell)
    self.view.addSubview(@table)
  end

  def registerEvents
    'UserNotificationsFetched'.add_observer(self, 'displayNotifications')
  end

  def numberOfSectionsInTableView
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @user.notifications.count
  end

  def tableView(tableView, heightForRowAtIndexPath: indexPath)
    67
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = @table.dequeueReusableCellWithIdentifier(NotificationCell.reuseIdentifier) || begin
      NotificationCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier: NotificationCell.reuseIdentifier)
    end

    cell.notification = @user.notifications[indexPath.row]
    cell.render
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
  end

  def displayNotifications
    @table.reloadData
  end

end