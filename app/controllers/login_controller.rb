class LoginController < UIViewController

  attr_accessor :data, :usernameCell, :passwordCell

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
    @loginTable = UITableView.alloc.initWithFrame(self.view.bounds, style: UITableViewStyleGrouped)
    @loginTable.delegate = self
    @loginTable.dataSource = self
    @loginTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    self.view.addSubview @loginTable

    submitButton = UIButton.alloc.initWithFrame(CGRectMake(44, 148, 936, 44), style: UIButtonTypeRoundedRect)
    submitButton.titleLabel.text = 'Sign in'
    self.view.insertSubview(submitButton, aboveSubview:@loginTable)
    self.view.bringSubviewToFront(submitButton)
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

  private

  def createCustomCells
    # TODO: refactor
    @usernameCell = UITableViewCell.alloc.initWithFrame(CGRectMake(0, 0, 1024, 44))
    @usernameCell.selectionStyle = UITableViewCellSelectionStyleNone
    usernameField = UITextField.alloc.initWithFrame(CGRectMake(8, 7, 1009, 30))
    usernameField.attributedPlaceholder = NSAttributedString.alloc.initWithString('Username or email')
    @usernameCell.contentView.addSubview(usernameField)

    @passwordCell = UITableViewCell.alloc.initWithFrame(CGRectMake(0, 0, 1024, 44))
    @passwordCell.selectionStyle = UITableViewCellSelectionStyleNone
    passwordField = UITextField.alloc.initWithFrame(CGRectMake(8, 7, 1009, 30))
    passwordField.attributedPlaceholder = NSAttributedString.alloc.initWithString('Password')
    passwordField.secureTextEntry = true
    @passwordCell.contentView.addSubview(passwordField)
  end

end