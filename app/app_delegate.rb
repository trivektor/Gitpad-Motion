class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.backgroundColor = UIColor.whiteColor
    @window.makeKeyAndVisible

    UINavigationBar.appearance.setTintColor(UIColor.whiteColor)

    UINavigationBar.appearance.setTitleTextAttributes({
      UITextAttributeTextColor => UIColor.colorWithRed(131/255.0, green: 131/255.0, blue: 131/255.0, alpha: 1.0)
    })

    validateAuthenticationToken
    true
  end

  def validateAuthenticationToken
    authToken = SSKeychain.passwordForService('access_token', account:APP_KEYCHAIN_ACCOUNT)

    puts "authToken when app starts is #{authToken}"

    if !authToken
      loginController = LoginController.alloc.init
      navController = UINavigationController.alloc.initWithRootViewController(loginController)
      @window.rootViewController = navController
    else
      loadingController = LoadingController.alloc.init
      @window.rootViewController = loadingController
    end
  end
end
