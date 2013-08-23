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
    @center = NSNotificationCenter.defaultCenter
    @center.addObserver(self, selector:'enterMainStage:', name:'AuthenticatedUserFetched', object:nil)
  end

  def enterMainStage(notification)
    puts 'entering main stage'
    currentUser = notification.object
    SSKeychain.setPassword(currentUser.login, forService:'username', account:APP_KEYCHAIN_ACCOUNT)
    AppInitialization.run(self.view.window, withUser:currentUser)
  end

end