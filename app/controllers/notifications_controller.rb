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

    @titleLabel = UILabel.alloc.initWithFrame([[40, 11], [950, 21]])
    @titleLabel.font = UIFont.fontWithName('Roboto-Light', size: 15)
    @titleLabel.textColor = UIColor.iOS7darkBlueColor
    @titleLabel.backgroundColor = UIColor.clearColor

    @dateLabel = UILabel.alloc.initWithFrame([[40, 32], [950, 21]])
    @dateLabel.font = UIFont.fontWithName('Roboto-Light', size: 15)
    @dateLabel.backgroundColor = UIColor.clearColor

    self.contentView.addSubview(@fontAwesomeLabel)
    self.contentView.addSubview(@titleLabel)
    self.contentView.addSubview(@dateLabel)
  end

  def render
    @titleLabel.text = @notification.title
    @dateLabel.text = @notification.updatedAt

    self.contentView.backgroundColor = notification.read? ? '#f5f5f5'.uicolor : UIColor.whiteColor
    @fontAwesomeLabel.text = FontAwesome.icon(ICONS[notification.type][:icon])
    @fontAwesomeLabel.textColor = UIColor.iOS7darkBlueColor
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
    'NotificationDetailsFetched'.add_observer(self, 'displayNotificationDetails:')
  end

  def numberOfSectionsInTableView(tableView)
    @user.notifications.keys.count
  end

  def tableView(tableView, heightForHeaderInSection: section)
    30
  end

  def tableView(tableView, numberOfRowsInSection: section)
    return 0 if @user.notifications == {}
    repoName = @user.notifications.keys[section]
    @user.notifications[repoName].count
  end

  def tableView(tableView, titleForHeaderInSection: section)
    @user.notifications.keys[section]
  end

  def tableView(tableView, viewForHeaderInSection: section)
    label = UILabel.alloc.initWithFrame([[10, 3], [1024, 25]])
    label.font = UIFont.fontWithName('Roboto-Bold', size: 15)
    label.textColor = UIColor.iOS7pinkColor
    label.text = tableView(tableView, titleForHeaderInSection: section)
    label.backgroundColor = UIColor.clearColor

    backgroundView = UIView.alloc.initWithFrame([[0, 0], [1024, 25]])
    backgroundView.setBackgroundColor('#eee'.uicolor)
    backgroundView.addSubview(label)
    backgroundView
  end

  def tableView(tableView, heightForRowAtIndexPath: indexPath)
    67
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = @table.dequeueReusableCellWithIdentifier(NotificationCell.reuseIdentifier) || begin
      NotificationCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier: NotificationCell.reuseIdentifier)
    end

    repoName = @user.notifications.keys[indexPath.section]

    cell.notification = @user.notifications[repoName][indexPath.row]
    cell.render
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    repoName = @user.notifications.keys[indexPath.section]
    repo = @user.notifications[repoName][indexPath.row]
    repo.fetch
  end

  def displayNotifications
    @table.reloadData
  end

  def displayNotificationDetails(notification)
    issueController = IssueController.alloc.init
    issueController.issue = notification.object
    self.navigationController.pushViewController(issueController, animated: true)
  end

end