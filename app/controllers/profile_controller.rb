class ProfileCell < UITableViewCell

  attr_accessor :user, :fontAwesomeLabel, :fieldNameLabel, :fieldValueLabel

  PRESENTATION_DATA = {
    0 => {icon: 'map-marker', fieldName: 'Location'},
    1 => {icon: 'globe', fieldName: 'Website'},
    2 => {icon: 'envelope', fieldName: 'Email'},
    3 => {icon: 'briefcase', fieldName: 'Company'},
    4 => {icon: 'group', fieldName: 'Followers'},
    5 => {icon: 'group', fieldName: 'Following'},
    6 => {icon: 'folder-open', fieldName: 'Repos'},
    7 => {icon: 'code', fieldName: 'Gists'},
    8 => {icon: 'calendar', fieldName: 'Joined'},
    9 => {icon: 'sitemap', fieldName: 'Organizations'},
    10 => {icon: 'rss', fieldName: 'Recent Activity'},
    11 => {icon: 'trophy', fieldName: 'Contributions'}
  }

  def initWithStyle(style, reuseIdentifier: identifier)
    super
    createLabels
    self
  end

  def renderForRowAtIndexPath(indexPath)
    @fontAwesomeLabel.text = FontAwesome.icon(PRESENTATION_DATA[indexPath.row][:icon])
    @fieldNameLabel.text = PRESENTATION_DATA[indexPath.row][:fieldName]

    fieldValue = ''

    case indexPath.row
    when 0
      fieldValue = @user.location
    when 1
      fieldValue = @user.website
    when 2
      fieldValue = @user.email
    when 3
      fieldValue = @user.company
    when 4
      fieldValue = @user.followers
    when 5
      fieldValue = @user.following
    when 6
      fieldValue = @user.numPublicRepos
    when 7
      fieldValue = @user.numPublicGists
    when 8
      fieldValue = @user.createdAt
    when 9
      fieldValue = 'view all'
    when 10
      fieldValue = 'view all'
    when 11
      fieldValue = 'view all'
    end

    @fieldValueLabel.text = fieldValue.to_s
  end

  def createLabels
    @fontAwesomeLabel = UILabel.alloc.initWithFrame([[20, 14], [29, 21]])
    @fontAwesomeLabel.font = FontAwesome.fontWithSize(15)
    @fieldNameLabel = UILabel.alloc.initWithFrame([[67, 14], [105, 21]])
    @fieldNameLabel.font = UIFont.fontWithName('Roboto-Light', size: 15)
    @fieldValueLabel = UILabel.alloc.initWithFrame([[257, 14], [650, 21]])
    @fieldValueLabel.font = UIFont.fontWithName('Roboto-Light', size: 15)

    self.contentView.addSubview(@fontAwesomeLabel)
    self.contentView.addSubview(@fieldNameLabel)
    self.contentView.addSubview(@fieldValueLabel)
    self.backgroundColor = UIColor.whiteColor
  end

end

class ProfileController < UIViewController

  attr_accessor :user, :table

  def initWithNibName(nibName, bundle: nibBundle)
    super
    self
  end

  def viewDidLoad
    super
    performHousekeepingTasks
    loadHud
    registerEvents
    fetchProfileInfo
  end

  def performHousekeepingTasks
    @table = UITableView.alloc.initWithFrame(self.view.bounds, style: UITableViewStyleGrouped)
    @table.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    @table.delegate = self
    @table.dataSource = self
    @table.scrollEnabled = false
    @table.registerClass(ProfileCell, forCellReuseIdentifier: ProfileCell.reuseIdentifier)
    @table.backgroundView = nil

    self.view.addSubview(@table)
    self.view.setBackgroundColor(UIColor.whiteColor)
  end

  def registerEvents
    NSNotificationCenter.defaultCenter.addObserver(self, selector: 'displayProfileInfo:', name: 'ProfileInfoFetched', object: nil)
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    12
  end

  def tableView(tableView, heightForRowAtIndexPath: indexPath)
    51
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = @table.dequeueReusableCellWithIdentifier(ProfileCell.reuseIdentifier) || begin
      ProfileCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: ProfileCell.reuseIdentifier)
    end

    cell.user = @user

    cell.renderForRowAtIndexPath(indexPath)
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    case indexPath.row
    when 0
    when 4
      followersController = FollowersController.alloc.init
      followersController.user = @user
      self.navigationController.pushViewController(followersController, animated: true)
    when 5
      followingController = FollowingController.alloc.init
      followingController.user = @user
      self.navigationController.pushViewController(followingController, animated: true)
    end
  end

  def fetchProfileInfo
    showHud
    @user.fetchProfileInfo
  end

  def displayProfileInfo(notifcation)
    @user = notifcation.object
    self.navigationItem.title = "#{@user.login}'s profile"
    @table.reloadData
    hideHud
  end

end