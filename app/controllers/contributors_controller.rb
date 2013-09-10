class ContributorsController < UIViewController

  attr_accessor :repo, :contributions

  def initWithNibName(nibName, bundle: nibBundle)
    super
    @contributions = []
    self
  end

  def viewDidLoad
    super
    createBackButton
    performHousekeepingTasks
    registerEvents
    @repo.fetchContributors
  end

  def performHousekeepingTasks
    self.navigationItem.title = 'Contributors'

    @table = createTable
    self.view.addSubview(@table)
  end

  def registerEvents
    'ContributorsFetched'.add_observer(self, 'displayContributors')
  end

  def displayContributors
    @table.reloadData
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @repo.contributors.count
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = @table.dequeueReusableCellWithIdentifier('Cell') || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: 'Cell')
    end

    contribution = @repo.contributors[indexPath.row]
    cell.textLabel.text = contribution.author.login
    cell.textLabel.font = FontAwesome.fontWithSize(15)
    cell.imageView.setImageWithURL(contribution.author.avatarUrl.nsurl, placeholderImage: UIImage.imageNamed(AVATAR_PLACEHOLDER))
    cell.defineAccessoryType

    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)

  end

end