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
    @table = createTable
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

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = @table.dequeueReusableCellWithIdentifier('Cell') || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier: 'Cell')
    end

    notification = @user.notifications[indexPath.row]

    cell.textLabel.font = UIFont.fontWithName('Roboto-Bold', size: 15)
    cell.textLabel.text = notification.title
    cell.detailTextLabel.font = UIFont.fontWithName('Roboto-Light', size: 15)
    cell.detailTextLabel.text = notification.lastReadAt
    cell
  end

  def displayNotifications
    @table.reloadData
  end

end