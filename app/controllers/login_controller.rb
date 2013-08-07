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

    containerView = UIView.alloc.initWithFrame(self.view.bounds)
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    self.view.addSubview containerView

    @loginTable = UITableView.alloc.initWithFrame(containerView.bounds, style: UITableViewStyleGrouped)
    @loginTable.delegate = self
    @loginTable.dataSource = self
    @loginTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    @loginTable.backgroundView = nil
    containerView.addSubview @loginTable

    submitButton = UIButton.alloc.initWithFrame(CGRectMake(44, 143, 936, 44), style: UIButtonTypeRoundedRect)
    submitButton.setTitle('Submit', forState: UIControlStateNormal)
    submitButton.titleLabel.textColor = UIColor.whiteColor
    submitButton.backgroundColor = UIColor.colorWithRed(72/255.0, green: 201/255.0, blue: 176/255.0, alpha: 1.0)
    submitButton.layer.cornerRadius = 6.0
    containerView.addSubview(submitButton, aboveSubview: @loginTable)
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
    usernameField = UITextField.alloc.initWithFrame(CGRectMake(8, 7, 916, 30))
    usernameField.attributedPlaceholder = NSAttributedString.alloc.initWithString('Username or email')
    @usernameCell.backgroundColor = UIColor.whiteColor
    @usernameCell.contentView.addSubview(usernameField)

    @passwordCell = UITableViewCell.alloc.initWithFrame(CGRectMake(0, 0, 1024, 44))
    @passwordCell.selectionStyle = UITableViewCellSelectionStyleNone
    passwordField = UITextField.alloc.initWithFrame(CGRectMake(8, 7, 916, 30))
    passwordField.attributedPlaceholder = NSAttributedString.alloc.initWithString('Password')
    passwordField.secureTextEntry = true
    @passwordCell.backgroundColor = UIColor.whiteColor
    @passwordCell.contentView.addSubview(passwordField)
  end

end