class AppDelegate

  attr_accessor :window

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    self.window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    self.window.backgroundColor = UIColor.whiteColor
    self.window.makeKeyAndVisible

    UINavigationBar.appearance.setTintColor(UIColor.whiteColor)

    UINavigationBar.appearance.setTitleTextAttributes({
      UITextAttributeTextColor => UIColor.colorWithRed(131/255.0, green: 131/255.0, blue: 131/255.0, alpha: 1.0)
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
