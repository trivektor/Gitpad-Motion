class OrganizationsController < UIViewController

  attr_accessor :user

  def viewDidLoad
    super
    createBackButton
    performHousekeepingTasks
    registerEvents
    @user.fetchOrganizations
  end

  def performHousekeepingTasks
    self.navigationItem.title = "#{user.login}'s Organizations"
    @user.resetOrganizations
    @table = createTable
    self.view.addSubview(@table)
  end

  def registerEvents
    'OrganizationsFetched'.add_observer(self, 'displayOrganizations')
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @user.organizations.count
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = @table.dequeueReusableCellWithIdentifier('Cell') || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: 'Cell')
    end

    organization = @user.organizations[indexPath.row]

    cell.imageView.setImageWithURL(organization.avatarUrl.nsurl, placeholderImage: UIImage.imageNamed('avatar-placeholder.png'))
    cell.textLabel.font = UIFont.fontWithName('Roboto-Light', size: 15)
    cell.textLabel.text = organization.login
    cell
  end

  def displayOrganizations
    @table.reloadData
  end

end