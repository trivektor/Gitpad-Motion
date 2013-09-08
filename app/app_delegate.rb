class AppDelegate

  attr_accessor :window

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    self.window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    self.window.backgroundColor = UIColor.whiteColor
    self.window.makeKeyAndVisible

    UIBarButtonItem.configureFlatButtonsWithColor(UIColor.whiteColor,
      highlightedColor: UIColor.whiteColor,
      cornerRadius: 4);

    UINavigationBar.appearance.setTintColor(UIColor.whiteColor)

    UINavigationBar.appearance.setTitleTextAttributes({
      UITextAttributeTextColor => UIColor.iOS7darkBlueColor,
      UITextAttributeFont => UIFont.fontWithName('Roboto-Regular', size: 19),
      UITextAttributeTextShadowColor => UIColor.clearColor
    })

    validateAuthenticationToken
    true
  end

  def validateAuthenticationToken
    authToken = AppHelper.getAccessToken

    puts "authToken when app starts is #{authToken}"

    if !authToken
      loginController = LoginController.alloc.init
      navController = UINavigationController.alloc.initWithRootViewController(loginController)
      self.window.rootViewController = navController
    else
      loadingController = LoadingController.alloc.init
      self.window.rootViewController = loadingController
    end
  end
end
