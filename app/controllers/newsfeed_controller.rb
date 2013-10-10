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
    @descriptionLabel.text = @event.relativeCreatedAt
    self.defineAccessoryType
  end

end

class NewsfeedController < UIViewController

  attr_accessor :page, :user

  def init
    super
    @page = 1
    self
  end

  def viewDidLoad
    super
    createBackButton
    performHousekeepingTasks
    registerEvents
    loadHud
    fetchEvents
  end

  def performHousekeepingTasks
    self.navigationItem.title = title

    @table = createTable(cell: NewsfeedCell)
    self.view.addSubview(@table)
  end

  def title
    'Newsfeed'
  end

  def registerEvents
    'NewsFeedFetched'.add_observer(self, 'displayEvents')
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @user.events.count
  end

  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    57
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = @table.dequeueReusableCellWithIdentifier(NewsfeedCell.reuseIdentifier) || begin
      NewsfeedCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:NewsfeedCell.reuseIdentifier)
    end

    cell.event = eventForRowAtIndexPath(indexPath)
    cell.render
    cell
  end

  # def tableView(tableView, willDisplayCell: cell, forRowAtIndexPath: indexPath)
  #   rotation = CATransform3DMakeRotation( (90.0 * 3.14)/180, 0.0, 0.7, 0.4)
  #   rotation.m34 = 1.0/ -600
  #
  #   cell.layer.shadowColor = :black.uicolor.cgcolor
  #   cell.layer.shadowOffset = CGSizeMake(10, 10)
  #   cell.alpha = 0
  #   cell.layer.transform = rotation
  #   cell.layer.anchorPoint = CGPointMake(0, 0.5)
  #   UIView.beginAnimations('rotation', context: nil)
  #   UIView.setAnimationDuration(0.8)
  #   cell.layer.transform = CATransform3DIdentity
  #   cell.alpha = 1
  #   cell.layer.shadowOffset = CGSizeMake(0, 0)
  #   UIView.commitAnimations
  # end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    'CloseViewDeck'.post_notification
    detailsController = NewsfeedDetailsController.alloc.init
    detailsController.event = eventForRowAtIndexPath(indexPath)
    self.navigationController.pushViewController(detailsController, animated: true)
  end

  def eventForRowAtIndexPath(indexPath)
    @user.events[indexPath.row]
  end

  def scrollViewDidScroll(scrollView)
    if scrollView.contentOffset.y + scrollView.frame.size.height == scrollView.contentSize.height
      fetchEvents
    end
  end

  def displayEvents
    @table.reloadData
    hideHud
  end

  def fetchEvents
    showHud
    user.fetchNewsfeedForPage(@page)
    @page += 1
  end

end

class ActivitiesController < NewsfeedController

  def performHousekeepingTasks
    super
    @user.resetActivities
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @user.activities.count
  end

  def title
    'Recent Activity'
  end

  def registerEvents
    'ActivitiesFetched'.add_observer(self, 'displayEvents')
  end

  def eventForRowAtIndexPath(indexPath)
    @user.activities[indexPath.row]
  end

  def fetchEvents
    showHud
    user.fetchActivitiesForPage(@page)
    @page += 1
  end

end