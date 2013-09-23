class LoginController < UIViewController

  include AFNetWorking

  def viewDidLoad
    super
    performHouseKeepingTasks
    createCustomCells
    registerEvents
  end

  def performHouseKeepingTasks
    navigationItem.title = 'Login'

    @loginTable = createTable(style: UITableViewStyleGrouped)
    self.view.addSubview(@loginTable)

    submitButton = UIButton.alloc.initWithFrame(CGRectMake(44, 143, 936, 44), style: UIButtonTypeRoundedRect)
    submitButton.setTitle('Submit', forState: UIControlStateNormal)
    submitButton.titleLabel.textColor = UIColor.whiteColor
    submitButton.titleLabel.font = UIFont.fontWithName('Roboto-Bold', size: 17)
    submitButton.backgroundColor = UIColor.colorWithRed(72/255.0, green: 201/255.0, blue: 176/255.0, alpha: 1.0)
    submitButton.layer.cornerRadius = 6.0
    submitButton.addTarget(self, action: 'login', forControlEvents: UIControlEventTouchUpInside);
    self.view.addSubview(submitButton, aboveSubview: @loginTable)
  end

  def registerEvents
    'ExistingAuthorizationsDeleted'.add_observer(self, 'authenticate')
    'UserAutheticated'.add_observer(self, 'fetchUser')
  end

  def authenticate
    # TO BE IMPLEMENTED
    username = @usernameField.text || ''
    password = @passwordField.text || ''

    puts "authenticating"

    AFMotion::Client.shared.post('/authorizations', scopes: OAUTH_PARAMS[:scopes], note: 'Gitpad Motion auth') do |result|
      if result.success?
        puts "authorization created successfully"

        authorization = Authorization.new(result.object)
        puts authorization.token
        SSKeychain.deletePasswordForService('access_token', account:APP_KEYCHAIN_ACCOUNT)
        SSKeychain.setPassword(authorization.token, forService:'access_token', account:APP_KEYCHAIN_ACCOUNT)
        'UserAutheticated'.post_notification
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
    indexPath.row == 0 ? @usernameCell : @passwordCell
  end

  def login
    username = @usernameField.text || ''
    password = @passwordField.text || ''

    if username.length == 0 || password.length == 0
      UIAlertView.alert 'Please enter both username and password'
    else
      buildHttpClient
      AFMotion::Client.shared.get("/authorizations") do |result|
        if result.success?
          authorizations = result.object.map { |hash| Authorization.new(hash) }
          puts authorizations.inspect
          authorizations.each do |authorization|
            if authorization.name == APP_NAME
              puts "deleting existing authorization id: #{authorization.id}"
              AFMotion::Client.shared.delete("/authorizations/#{authorization.id}") do |result|
                if !result.success?
                  puts result.error.localizedDescription
                end
              end
              break
            end
          end
          'ExistingAuthorizationsDeleted'.post_notification
        elsif result.failure?
          UIAlertView.alert('Username or password is incorrect')
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