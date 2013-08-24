class LoginController < UIViewController

  def initWithNibName(nibName, bundle:nibBundle)
    super
    self
  end

  def viewDidLoad
    super
    navigationItem.title = 'Login'
    performHouseKeepingTasks
  end

  def performHouseKeepingTasks
    createCustomCells

    containerView = UIView.alloc.initWithFrame(self.view.bounds)
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    self.view.addSubview containerView

    @loginTable = UITableView.alloc.initWithFrame(containerView.bounds, style: UITableViewStyleGrouped)
    @loginTable.delegate = self
    @loginTable.dataSource = self
    @loginTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    @loginTable.backgroundView = nil
    @loginTable.scrollEnabled = false
    containerView.addSubview @loginTable

    submitButton = UIButton.alloc.initWithFrame(CGRectMake(44, 143, 936, 44), style: UIButtonTypeRoundedRect)
    submitButton.setTitle('Submit', forState: UIControlStateNormal)
    submitButton.titleLabel.textColor = UIColor.whiteColor
    submitButton.backgroundColor = UIColor.colorWithRed(72/255.0, green: 201/255.0, blue: 176/255.0, alpha: 1.0)
    submitButton.layer.cornerRadius = 6.0
    submitButton.addTarget(self, action:'login', forControlEvents:UIControlEventTouchUpInside);
    containerView.addSubview(submitButton, aboveSubview: @loginTable)

    registerEvents
  end

  def registerEvents
    @center = NSNotificationCenter.defaultCenter
    @center.addObserver(self, selector:'authenticate', name:'ExistingAuthorizationsDeleted', object:nil)
    @center.addObserver(self, selector:'fetchUser', name:'UserAutheticated', object:nil)
  end

  def authenticate
    # TO BE IMPLEMENTED
    username = @usernameField.text || ''
    password = @passwordField.text || ''

    puts "authenticating"

    AFMotion::Client.shared.post("/authorizations") do |result|
      if result.success?
        puts "authorization created successfully"

        authorization = Authorization.new(result.object)
        puts authorization.token
        SSKeychain.deletePasswordForService('access_token', account:APP_KEYCHAIN_ACCOUNT)
        SSKeychain.setPassword(authorization.token, forService:'access_token', account:APP_KEYCHAIN_ACCOUNT)
        @center.postNotificationName('UserAutheticated', object:nil)
      else
        puts result.error.localizedDescription
      end
    end
  end

  def fetchUser
    # TO BE IMPLEMENTED
    puts "fetching user"
    AFMotion::Client.shared.get("/user") do |result|
      currentUser = User.new(result.object)
      CurrentUserManager.initWithUser(currentUser)
      AppInitialization.run(self.view.window, withUser:currentUser)
    end
  end

  def tableView(tableView, numberOfRowsInSection: section)
    2
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    if indexPath.row == 0
      @usernameCell
    else
      @passwordCell
    end
  end

  def login
    username = @usernameField.text || ''
    password = @passwordField.text || ''

    @alert ||= UIAlertView.alloc.initWithTitle('Error',
      message:'Please enter both username and password',
      delegate:nil,
      cancelButtonTitle:'Back',
      otherButtonTitles:'OK')

    if username.length == 0 || password.length == 0
      @alert.show
    else
      AFMotion::Client.build_shared(GITHUB_API_HOST) do
        header "Accept", "application/json"
        authorization(username: username, password: password)
        parameter_encoding :json
        operation :json
      end

      AFMotion::Client.shared.get("/authorizations") do |result|
        if result.success?
          authorizations = result.object.map { |hash| Authorization.new(hash) }
          puts authorizations.inspect
          authorizations.each do |authorization|
            if authorization.name == APP_NAME
              puts "deleting existing authorization id: #{authorization.id}"
              AFMotion::Client.shared.delete("/authorizations/#{authorization.id}") do |result|
                if result.success?

                else
                  puts result.error.localizedDescription
                end
              end
              break
            end
          end
          NSNotificationCenter.defaultCenter.postNotificationName('ExistingAuthorizationsDeleted', object:nil)
        elsif result.failure?
          @alert.setMessage(result.error.localizedDescription)
          @alert.show
        end
      end
    end
  end

  private

  def createCustomCells
    # TODO: refactor
    @usernameCell = UITableViewCell.alloc.initWithFrame(CGRectMake(0, 0, 1024, 44))
    @usernameCell.selectionStyle = UITableViewCellSelectionStyleNone
    @usernameField = UITextField.alloc.initWithFrame(CGRectMake(8, 7, 916, 30))
    @usernameField.attributedPlaceholder = NSAttributedString.alloc.initWithString('Username or email')
    @usernameField.setAutocorrectionType(UITextAutocorrectionTypeNo)
    @usernameField.setAutocapitalizationType(UITextAutocapitalizationTypeNone)
    @usernameCell.backgroundColor = UIColor.whiteColor
    @usernameCell.contentView.addSubview(@usernameField)

    @passwordCell = UITableViewCell.alloc.initWithFrame(CGRectMake(0, 0, 1024, 44))
    @passwordCell.selectionStyle = UITableViewCellSelectionStyleNone
    @passwordField = UITextField.alloc.initWithFrame(CGRectMake(8, 7, 916, 30))
    @passwordField.attributedPlaceholder = NSAttributedString.alloc.initWithString('Password')
    @passwordField.secureTextEntry = true
    @passwordCell.backgroundColor = UIColor.whiteColor
    @passwordCell.contentView.addSubview(@passwordField)
  end

end