class FollowController < UIViewController

  attr_accessor :user, :page, :table

  def initWithNibName(nibName, bundle:nibBundle)
    super
    @page = 1
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
    'FollowUsersFetched'.add_observer(self, 'displayFollowUsers')
  end

  def performHouseKeepingTasks
    @table = createTable
    self.view.addSubview(@table)
  end

  def displayFollowUsers
    @table.reloadData
    hideHud
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier('Cell') || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: 'Cell')
    end

    user = getUserForRowAtIndexPath(indexPath)

    cell.textLabel.font = UIFont.fontWithName('Roboto-Light', size: 15)
    cell.textLabel.text = user.login
    cell.imageView.setImageWithURL(user.avatarUrl.nsurl, placeholderImage: UIImage.imageNamed('avatar-placeholder.png'))
    cell.defineAccessoryType

    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    @profileController = ProfileController.alloc.init
    @profileController.user = getUserForRowAtIndexPath(indexPath)
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

  def tableView(tableView, numberOfRowsInSection: section)
    @user.following.count
  end

  def getUserForRowAtIndexPath(indexPath)
    @user.following[indexPath.row]
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

  def tableView(tableView, numberOfRowsInSection: section)
    @user.followers.count
  end

  def getUserForRowAtIndexPath(indexPath)
    @user.followers[indexPath.row]
  end

  def scrollViewDidScroll(scrollView)
    if scrollView.contentOffset.y + scrollView.frame.size.height == scrollView.contentSize.height
      fetchFollowers
    end
  end

end

class WatchersController < FollowController

  attr_accessor :repo

  def viewDidLoad
    super
    self.navigationItem.title = "#{repo.name}'s watchers"
    fetchWatchers
  end

  def registerEvents
    'RepoWatchersFetched'.add_observer(self, 'displayWatchers')
  end

  def fetchWatchers
    showHud
    @repo.fetchWatchers(@page)
    @page += 1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @repo.watchers.count
  end

  def getUserForRowAtIndexPath(indexPath)
    @repo.watchers[indexPath.row]
  end

  def displayWatchers
    @table.reloadData
    hideHud
  end

  def scrollViewDidScroll(scrollView)
    if scrollView.contentOffset.y + scrollView.frame.size.height == scrollView.contentSize.height
      fetchWatchers
    end
  end

end