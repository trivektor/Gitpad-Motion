class NewsfeedCell < UITableViewCell

  attr_accessor :event, :titleLabel, :descriptionLabel

  def initWithStyle(style, reuseIdentifier:identifier)initialize
    super
    createLabels
    self
  end

  def createLabels
    @iconLabel = UILabel.alloc.initWithFrame(CGRectMake(20, 9, 20, 21))
    @titleLabel = UILabel.alloc.initWithFrame(CGRectMake(53, 8, 916, 21))
    @descriptionLabel = UILabel.alloc.initWithFrame(CGRectMake(53, 28, 916, 21))

    self.contentView.addSubview(@iconLabel)
    self.contentView.addSubview(@titleLabel)
    self.contentView.addSubview(@descriptionLabel)
  end

  def self.reuseIdentifier
    to_s
  end

  def render
    @titleLabel.text = @event.toString
    @descriptionLabel.text = ''
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
    fetchUserNewsfeed
  end

  def performHousekeepingTasks
    @table = UITableView.alloc.initWithFrame(self.view.bounds, style:UITableViewStylePlain)
    @table.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    @table.delegate = self
    @table.dataSource = self
    @table.registerClass(NewsfeedCell, forCellReuseIdentifier:NewsfeedCell.reuseIdentifier)

    self.view.addSubview(@table)
  end

  def registerEvents
    NSNotificationCenter.defaultCenter.addObserver(self, selector: 'displayUserNewsfeed:', name: 'NewsFeedFetched', object: nil)
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    10
  end

  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    57
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = @table.dequeueReusableCellWithIdentifier(NewsfeedCell.reuseIdentifier)

    if !cell
      cell = NewsfeedCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:NewsfeedCell.reuseIdentifier)
    end

    cell.event = @events[indexPath.row]
    cell
  end

  def displayUserNewsfeed(notification)
    events = notification.object
    @table.reloadData
  end

  def fetchUserNewsfeed
    currentUser = CurrentUserManager.sharedInstance
    currentUser.fetchNewsfeedForPage(@page)
    @page += 1
  end

end