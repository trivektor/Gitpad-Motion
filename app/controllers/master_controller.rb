class MasterProfileCell < UITableViewCell

  attr_accessor :image, :textLabel

  def initWithStyle(style, reuseIdentifier:identifier)
    super
    self.createLabels
    self
  end

  def createLabels
    @image = UIImageView.alloc.initWithFrame([[15, 9], [26, 26]])

    @textLabel = UILabel.alloc.initWithFrame([[51, 11], [243, 21]])
    @textLabel.textColor = UIColor.whiteColor
    @textLabel.backgroundColor = UIColor.clearColor
    @textLabel.font = UIFont.fontWithName('Roboto-Medium', size:13)

    self.contentView.addSubview(@image)
    self.contentView.addSubview(@textLabel)
  end

  def displayAvatarAndUsername
    currentUser = CurrentUserManager.sharedInstance
    userImageData = NSData.dataWithContentsOfURL(currentUser.avatarUrl.nsurl)
    @image.image = UIImage.imageWithData(userImageData)
    @image.layer.masksToBounds = true
    @image.layer.cornerRadius = 3

    @textLabel.text = currentUser.login

    selectedBackgroundView = UIView.alloc.initWithFrame(self.frame)
    selectedBackgroundView.backgroundColor = UIColor.iOS7redColor
    self.selectedBackgroundView = selectedBackgroundView
  end

  def self.reuseIdentifier
    to_s
  end

end

class MasterControllerCell < UITableViewCell

  attr_accessor :iconLabel, :textLabel

  def initWithStyle(style, reuseIdentifier:identifier)
    super
    self.createLabels
    self
  end

  def createLabels
    @iconLabel = UILabel.alloc.initWithFrame([[15, 9], [25, 25]])
    @iconLabel.textColor = UIColor.whiteColor
    @iconLabel.backgroundColor = UIColor.clearColor

    @textLabel = UILabel.alloc.initWithFrame([[51, 11], [243, 21]])
    @textLabel.textColor = UIColor.whiteColor
    @textLabel.backgroundColor = UIColor.clearColor
    @textLabel.font = UIFont.fontWithName('Roboto-Light', size: 13)

    selectedBackgroundView = UIView.alloc.initWithFrame(self.frame)
    selectedBackgroundView.backgroundColor = UIColor.iOS7redColor
    self.selectedBackgroundView = selectedBackgroundView

    self.contentView.addSubview(@iconLabel)
    self.contentView.addSubview(@textLabel)
  end

  def renderForIndexPath(indexPath)
    @iconLabel.font = FontAwesome.fontWithSize(16)

    case indexPath.section
    when 0
      self.displayAvatarAndUsername
    when 1
      @iconLabel.text = FontAwesome.icon('rss')
      @textLabel.text = 'News Feed'
    when 2
      case indexPath.row
      when 0
        @iconLabel.text = FontAwesome.icon('github')
        @textLabel.text = 'Personal'
      when 1
        @iconLabel.text = FontAwesome.icon('star-empty')
        @textLabel.text = 'Starred'
      when 2
        @iconLabel.text = FontAwesome.icon('plus-sign')
        @textLabel.text = 'New Repository'
      end
    when 3
      case indexPath.row
      when 0
        @iconLabel.text = FontAwesome.icon('code')
        @textLabel.text = 'Gists'
      when 1
        @iconLabel.text = FontAwesome.icon('search')
        @textLabel.text = 'Search'
      when 2
        @iconLabel.text = FontAwesome.icon('bullhorn')
        @textLabel.text = 'Notifications'
      when 3
        @iconLabel.text = FontAwesome.icon('envelope')
        @textLabel.text = 'Feedback'
      when 4
        @iconLabel.text = FontAwesome.icon('off')
        @textLabel.text = 'Sign out'
      when 5
        @iconLabel.text = FontAwesome.icon('legal')
        @textLabel.text = 'Attributions'
      end
    end
  end

  def self.reuseIdentifier
    to_s
  end

end

class MasterController < UIViewController

  attr_accessor :user, :table

  def initWithNibName(nibName, bundle:nibBundle)
    super
    self
  end

  def viewDidLoad
    super
    performHousekeepingTasks
    registerEvents
  end

  def performHousekeepingTasks
    @table = createTable
    @table.setBackgroundColor(UIColor.colorWithRed(55/255.0, green:55/255.0, blue:55/255.0, alpha:1.0))
    @table.setSeparatorColor(UIColor.clearColor)
    @table.registerClass(MasterControllerCell, forCellReuseIdentifier:MasterControllerCell.reuseIdentifier)
    @table.registerClass(MasterProfileCell, forCellReuseIdentifier:MasterProfileCell.reuseIdentifier)
    self.view.addSubview(@table)
  end

  def registerEvents
    'ToggleViewDeck'.add_observer(self, 'toggleViewDeck')
    'CloseViewDeck'.add_observer(self, 'closeViewDeck')
  end

  def numberOfSectionsInTableView(tableView)
    4
  end

  def tableView(tableView, numberOfRowsInSection:section)
    case section
    when 0
      1
    when 1
      1
    when 2
      3
    when 3
      6
    else
      0
    end
  end

  def tableView(tableView, heightForHeaderInSection:section)
    25
  end

  def tableView(tableView, viewForHeaderInSection:section)
    headerLabel = UILabel.alloc.initWithFrame(CGRectMake(8, 1, 300, 25))
    headerLabel.backgroundColor = UIColor.clearColor
    headerLabel.text = self.tableView(tableView, titleForHeaderInSection:section)
    headerLabel.textColor = UIColor.whiteColor
    headerLabel.font = UIFont.fontWithName('Roboto-Medium', size: 12)
    backgroundView = UIView.alloc.initWithFrame(CGRectMake(0, 0, 300, 25))
    backgroundView.backgroundColor = UIColor.colorWithRed(49/255.0, green:49/255.0, blue:49/255.0, alpha:0.9)
    backgroundView.addSubview(headerLabel)
    backgroundView
  end

  def tableView(tableView, titleForHeaderInSection:section)
    case section
    when 0
      'Profile'
    when 1
      'News Feed'
    when 2
      'Repositories'
    when 3
      'Others'
    end
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    if indexPath.section == 0 && indexPath.row == 0
      cell = MasterProfileCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:MasterProfileCell.reuseIdentifier)
      cell.displayAvatarAndUsername
    else
      cell = MasterControllerCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:MasterControllerCell.reuseIdentifier)
      cell.renderForIndexPath(indexPath)
    end

    cell
  end

  def tableView(tableView, willDisplayCell:cell, forRowAtIndexPath:indexPath)
    cell.backgroundColor = UIColor.colorWithPatternImage(UIImage.imageNamed('magma_border.png'))
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    case indexPath.section
    when 0
      if indexPath.row == 0
        profileController = ProfileController.alloc.init
        profileController.user = CurrentUserManager.sharedInstance
        selectedController = UINavigationController.alloc.initWithRootViewController(profileController)
      end
    when 1
      if indexPath.row == 0
        newsfeedController = NewsfeedController.alloc.init
        newsfeedController.user = CurrentUserManager.sharedInstance
        selectedController = UINavigationController.alloc.initWithRootViewController(newsfeedController)
      end
    when 2
      case indexPath.row
      when 0
        personalReposController = PersonalReposController.alloc.init
        personalReposController.user = CurrentUserManager.sharedInstance
        selectedController = UINavigationController.alloc.initWithRootViewController(personalReposController)
      when 1
        starredReposController = StarredReposController.alloc.init
        starredReposController.user = CurrentUserManager.sharedInstance
        selectedController = UINavigationController.alloc.initWithRootViewController(starredReposController)
      when 2
        newRepoController = NewRepoController.alloc.init
        selectedController = UINavigationController.alloc.initWithRootViewController(newRepoController)
      end
    when 3
      case indexPath.row
      when 0
        personalGistsController = GistsController.alloc.init
        personalGistsController.user = CurrentUserManager.sharedInstance
        selectedController = UINavigationController.alloc.initWithRootViewController(personalGistsController)
      when 1
        searchController = SearchController.alloc.init
        selectedController = UINavigationController.alloc.initWithRootViewController(searchController)
      when 2
        notificationsController = NotificationsController.alloc.init
        notificationsController.user = CurrentUserManager.sharedInstance
        selectedController = UINavigationController.alloc.initWithRootViewController(notificationsController)
      when 3
        feedbackController = FeedbackController.alloc.init
        selectedController = UINavigationController.alloc.initWithRootViewController(feedbackController)
      when 4
        @signoutConfirmSheet = UIActionSheet.alert('Are you sure you want to sign out?') do |pressed|
          self.signout if pressed == 'OK'
        end
        return
      when 5
        attributionsController = AttributionsController.alloc.init
        selectedController = UINavigationController.alloc.initWithRootViewController(attributionsController)
      end
    end

    navigateToSelectedController(selectedController)
  end

  def signout
    SSKeychain.deletePasswordForService('access_token', account: APP_KEYCHAIN_ACCOUNT)
    loginController = LoginController.alloc.init
    navController = UINavigationController.alloc.initWithRootViewController(loginController)
    self.view.window.setRootViewController(navController)
  end

  private

  def displayAvatarAndUsername
    # TO BE IMPLEMENTED
  end

  def toggleViewDeck
    # TO BE IMPLEMENTED
  end

  def closeViewDeck
    self.viewDeckController.closeLeftViewAnimated(true, completion: nil)
  end

  def navigateToSelectedController(selectedController)
    completion = lambda do |controller, success|
      controller.centerController = selectedController
    end

    self.viewDeckController.closeLeftViewAnimated(true, completion: completion)
  end

end