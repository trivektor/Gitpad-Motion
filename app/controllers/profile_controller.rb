class ProfileCell < UITableViewCell

  include RelativeTime

  attr_accessor :user, :fontAwesomeLabel, :fieldNameLabel, :fieldValueLabel, :isFollowing

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
      fieldValue = @user.location || 'not specified'
    when 1
      fieldValue = @user.website || 'not specified'
    when 2
      fieldValue = @user.email || 'not specified'
    when 3
      fieldValue = @user.company || 'not specified'
    when 4
      fieldValue = @user.numFollowers
    when 5
      fieldValue = @user.numFollowing
    when 6
      fieldValue = @user.numPublicRepos
    when 7
      fieldValue = @user.numPublicGists
    when 8
      fieldValue = relativeTime(@user.createdAt)
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
    createBackButton
    performHousekeepingTasks
    loadHud
    registerEvents
    fetchProfileInfo
    checkFollowing
  end

  def performHousekeepingTasks
    @table = createTable(scrollEnabled: false, style: UITableViewStyleGrouped)
    @table.registerClass(ProfileCell, forCellReuseIdentifier: ProfileCell.reuseIdentifier)

    self.view.addSubview(@table)
    self.view.setBackgroundColor(UIColor.whiteColor)
  end

  def registerEvents
    'ProfileInfoFetched'.add_observer(self, 'displayProfileInfo')
    'FollowingChecked'.add_observer(self, 'setupFollowOptions:')
    'UserFollowChanged'.add_observer(self, 'updateFollowOptions:')
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
    when 6
      personalReposController = PersonalReposController.alloc.init
      personalReposController.user = @user
      self.navigationController.pushViewController(personalReposController, animated: true)
    when 7
      gistsController = GistsController.alloc.init
      gistsController.user = @user
      self.navigationController.pushViewController(gistsController, animated: true)
    when 9
      organizationsController = OrganizationsController.alloc.init
      organizationsController.user = @user
      self.navigationController.pushViewController(organizationsController, animated: true)
    when 10
      activitiesController = ActivitiesController.alloc.init
      activitiesController.user = @user
      self.navigationController.pushViewController(activitiesController, animated: true)
    when 11
      contributionsController = ContributionsController.alloc.init
      contributionsController.user = @user
      self.navigationController.pushViewController(contributionsController, animated: true)
    end
  end

  def fetchProfileInfo
    showHud
    @user.fetchProfileInfo
  end

  def displayProfileInfo
    self.navigationItem.title = "#{@user.login}'s profile"
    @table.reloadData
    hideHud
  end

  def checkFollowing
    unless @user.myself?
      CurrentUserManager.sharedInstance.checkFollowing(@user)
    end
  end

  def setupFollowOptions(notification)
    operation = notification.object
    statusCode = operation.response.statusCode

    createOptionsAction(statusCode)
  end

  def createOptionsAction(statusCode)
    if statusCode == 404
      otherButtonTitles = 'Follow'
    elsif statusCode == 204
      otherButtonTitles = 'Unfollow'
    end

    @optionsActionSheet = IBActionSheet.alloc.initWithTitle(
      'Options',
      delegate: self,
      cancelButtonTitle: 'Cancel',
      destructiveButtonTitle: nil,
      otherButtonTitles: otherButtonTitles, 'View on Github', nil
    )
    @optionsActionSheet.setFont(UIFont.fontWithName('Roboto-Light', size: 15))
    @optionsActionSheet.setTitleFont(UIFont.fontWithName('Roboto-Bold', size: 17))
    @optionsActionSheet.setTitleTextColor(UIColor.iOS7redColor)

    optionsBtn = createFontAwesomeButton(
      icon: 'reorder',
      touchHandler: 'displayFollowOptions'
    )
    self.navigationItem.setRightBarButtonItem(optionsBtn)
  end

  def displayFollowOptions
    @optionsActionSheet.showInView(self.navigationController.view)
    @optionsActionSheet.rotateToCurrentOrientation
  end

  def updateFollowOptions(notification)
    statusCode = notification.object
    createOptionsAction(statusCode)

    message = if statusCode == 204
      @isFollowing = true
      "You are now following #{@user.login}"
    else
      @isFollowing = false
      "You've stopped following #{@user.login}"
    end

    alert = SIAlertView.alloc.initWithTitle('Alert', andMessage: message)
    alert.addButtonWithTitle('OK', type: 1, handler: nil)
    alert.show
  end

  def actionSheet(actionSheet, clickedButtonAtIndex: buttonIndex)
    if buttonIndex == 0
      currentUser = CurrentUserManager.sharedInstance
      @isFollowing ? currentUser.unfollow(@user) : currentUser.follow(@user)
    elsif buttonIndex == 1
    end
  end

end