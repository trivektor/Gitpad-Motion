class FollowController < UIViewController

  attr_accessor :user, :users, :page, :table

  def initWithNibName(nibName, bundle:nibBundle)
    super
    @page = 1
    @users = []
    self
  end

  def viewDidLoad
    super
    performHouseKeepingTasks
    createBackButton
    registerEvents
    loadHud
  end

  def registerEvents
    NSNotificationCenter.defaultCenter.addObserver(self, selector: 'displayFollowUsers:', name: 'FollowUsersFetched', object: nil)
  end

  def performHouseKeepingTasks
    @table = UITableView.alloc.initWithFrame(self.view.bounds, style: UITableViewStylePlain)
    @table.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    @table.delegate = self
    @table.dataSource = self
    @table.scrollEnabled = true

    self.view.addSubview(@table)
  end

  def displayFollowUsers(notification)
    @users += notification.object
    @table.reloadData
    hideHud
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @users.count
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier('Cell') || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: 'Cell')
    end

    user = @users[indexPath.row]

    cell.textLabel.font = UIFont.fontWithName('Roboto-Light', size: 15)
    cell.textLabel.text = user.login
    cell.imageView.setImageWithURL(user.avatarUrl.nsurl, placeholderImage: UIImage.imageNamed('avatar-placeholder.png'))
    cell.defineAccessoryType

    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    @profileController = ProfileController.alloc.init
    @profileController.user = @users[indexPath.row]
    self.navigationController.pushViewController(@profileController, animated: true)
  end

end

class FollowingController < FollowController

  def viewDidLoad
    super
    self.navigationItem.title = 'Following'
    fetchFollowing
  end

  def fetchFollowing
    showHud
    @user.fetchFollowing(@page)
    @page += 1
  end

  def scrollViewDidScroll(scrollView)
    if scrollView.contentOffset.y + scrollView.frame.size.height == scrollView.contentSize.height
      fetchFollowing
    end
  end

end

class FollowersController < FollowController

  def viewDidLoad
    super
    self.navigationItem.title = 'Followers'
    fetchFollowers
  end

  def fetchFollowers
    showHud
    @user.fetchFollowers(@page)
    @page += 1
  end

  def scrollViewDidScroll(scrollView)
    if scrollView.contentOffset.y + scrollView.frame.size.height == scrollView.contentSize.height
      fetchFollowers
    end
  end

end