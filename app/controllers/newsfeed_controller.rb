class NewsfeedCell < UITableViewCell

  attr_accessor :event, :titleLabel, :descriptionLabel

  def initWithStyle(style, reuseIdentifier:identifier)
    super
    @event = nil
    createLabels
    self
  end

  def createLabels
    @iconLabel = UILabel.alloc.initWithFrame(CGRectMake(14, 9, 27, 21))
    @titleLabel = UILabel.alloc.initWithFrame(CGRectMake(40, 8, 916, 21))
    @descriptionLabel = UILabel.alloc.initWithFrame(CGRectMake(40, 28, 916, 21))

    self.contentView.addSubview(@iconLabel)
    self.contentView.addSubview(@titleLabel)
    self.contentView.addSubview(@descriptionLabel)
  end

  def render
    @titleLabel.font = UIFont.fontWithName('Roboto-Light', size: 13)
    @titleLabel.text = @event ? @event.toString : ''
    @iconLabel.font = FontAwesome.fontWithSize(15)
    @iconLabel.text = @event ? FontAwesome.icon(@event.icon) : ''
    @descriptionLabel.font = UIFont.fontWithName('Roboto-Light', size: 13)
    @descriptionLabel.text = @event.createdAt
    self.defineAccessoryType
  end

end

class NewsfeedController < UIViewController

  attr_accessor :page, :events

  def initWithNibName(nibName, bundle:nibBundle)
    super
    @page = 1
    @events = []
    self
  end

  def viewDidLoad
    super
    navigationItem.title = 'Newsfeed'
    performHousekeepingTasks
    registerEvents
    loadHud
    fetchUserNewsfeed
  end

  def performHousekeepingTasks
    @table = createTable
    @table.registerClass(NewsfeedCell, forCellReuseIdentifier: NewsfeedCell.reuseIdentifier)
    self.view.addSubview(@table)
  end

  def registerEvents
    'NewsFeedFetched'.add_observer(self, 'displayUserNewsfeed:')
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @events.count
  end

  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    57
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = @table.dequeueReusableCellWithIdentifier(NewsfeedCell.reuseIdentifier) || begin
      NewsfeedCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:NewsfeedCell.reuseIdentifier)
    end

    cell.event = @events[indexPath.row]
    cell.render
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    'CloseViewDeck'.post_notification
    detailsController = NewsfeedDetailsController.alloc.init
    detailsController.event = @events[indexPath.row]
    self.navigationController.pushViewController(detailsController, animated: true)
  end

  def scrollViewDidScroll(scrollView)
    if scrollView.contentOffset.y + scrollView.frame.size.height == scrollView.contentSize.height
      fetchUserNewsfeed
    end
  end

  def displayUserNewsfeed(notification)
    @events += notification.object
    @table.reloadData
    hideHud
  end

  def fetchUserNewsfeed
    showHud
    currentUser = CurrentUserManager.sharedInstance
    currentUser.fetchNewsfeedForPage(@page)
    @page += 1
  end

end