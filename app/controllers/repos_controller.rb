class RepoCell < UITableViewCell

  attr_accessor :repo, :nameLabel, :descriptionLabel

  def initWithStyle(style, reuseIdentifier:identifier)
    super
    createLabels
    self
  end

  def render
    @nameLabel.text = @repo.name
    @descriptionLabel.text = @repo.description
  end

  private

  def createLabels
    @nameLabel = UILabel.alloc.initWithFrame([[58, 9], [409, 21]])
    @nameLabel.font = UIFont.fontWithName('Roboto-Bold', size: 12)
    @descriptionLabel = UILabel.alloc.initWithFrame([[58, 34], [651, 21]])
    @descriptionLabel.font = UIFont.fontWithName('Roboto-Light', size: 13)

    self.contentView.addSubview(@nameLabel)
    self.contentView.addSubview(@descriptionLabel)
  end

end

class ReposController < UIViewController

  attr_accessor :table, :user, :repos, :page

  def initWithNibName(nibName, bundle:nibBundle)
    super
    @page = 1
    @repos = []
    self
  end

  def performHousekeepingTasks
    @table = UITableView.alloc.initWithFrame(self.view.bounds, style: UITableViewStylePlain)
    @table.delegate = self
    @table.dataSource = self
    @table.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    @table.scrollEnabled = true
    @table.registerClass(RepoCell, forCellReuseIdentifier: RepoCell.reuseIdentifier)

    self.view.addSubview(@table)
  end

  def viewDidLoad
    performHousekeepingTasks
  end

  def numberOfSectionsInTableView
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @repos.count
  end

  def tableView(tableView, heightForRowAtIndexPath: indexPath)
    67
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = @table.dequeueReusableCellWithIdentifier(RepoCell.reuseIdentifier)

    if !cell
      cell = RepoCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: RepoCell.reuseIdentifier)
    end

    cell.repo = @repos[indexPath.row]
    cell.render
    cell
  end

end

class PersonalReposController < ReposController

  def performHousekeepingTasks
    super
    self.navigationItem.title = 'Repositories'
    fetchReposForPage(@page)
    registerEvents
  end

  def registerEvents
    NSNotificationCenter.defaultCenter.addObserver(self, selector: 'displayRepos:', name: 'ReposFetched', object: nil)
  end

  def fetchReposForPage(page)
    self.user.fetchPersonalReposForPage(@page)
    @page += 1
  end

  def displayRepos(notification)
    self.repos = notification.object
    @table.reloadData
  end

end

class StarredReposController < ReposController

  def performHousekeepingTasks
    self.navigationItem.title = 'Starred Repositories'
  end

end