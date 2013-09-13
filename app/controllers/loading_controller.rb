class LoadingController < UIViewController

  def initWithNibName(nibName, bundle:nibBundle)
    super
    @hud = MBProgressHUD.showHUDAddedTo(@view, animated:true)
    @hud.mode = MBProgressHUDAnimationFade
    @hud.labelText = I18n.t('loading_message')
    self
  end

  def viewDidLoad
    super
    registerEvents
    User.fetchInfoForUserWithToken(AppHelper.getAccessToken)
  end

  def registerEvents
    'AuthenticatedUserFetched'.add_observer(self, 'enterMainStage:')
  end

  def enterMainStage(notification)
    puts 'entering main stage'
    currentUser = notification.object
    CurrentUserManager.initWithUser(currentUser)
    SSKeychain.setPassword(currentUser.login, forService: 'username', account: APP_KEYCHAIN_ACCOUNT)
    AppInitialization.run(self.view.window, withUser: currentUser)
  end

end