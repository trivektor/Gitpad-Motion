class ForksController < UIViewController

  attr_accessor :repo

  def viewDidLoad
    super
    createBackButton
    performHousekeepingTasks
    registerEvents
    @repo.fetchForks
  end

  def performHousekeepingTasks
    self.navigationItem.title = "#{repo.name}'s Forks"
    @table = createTable
    self.view.addSubview(@table)
  end

  def registerEvents
    'RepoForksFetched'.add_observer(self, 'displayForks')
  end

  def numberOfSectionsInTableView
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @repo.forks.count
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = @table.dequeueReusableCellWithIdentifier('Cell') || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: 'Cell')
    end

    fork = @repo.forks[indexPath.row]

    cell.imageView.setImageWithURL(fork.owner.avatarUrl.nsurl, placeholderImage: UIImage.imageNamed('avatar-placeholder.png'))
    cell.textLabel.font = UIFont.fontWithName('Roboto-Bold', size: 15)
    cell.textLabel.text = fork.fullName
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    repoController = RepoController.alloc.init
    repoController.repo = @repo.forks[indexPath.row]
    self.navigationController.pushViewController(repoController, animated: true)
  end

  def displayForks
    @table.reloadData
  end

end