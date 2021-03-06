class RepoCell < UITableViewCell

  attr_accessor :repo, :nameLabel, :descriptionLabel, :fontAwesomeLabel

  def initWithStyle(style, reuseIdentifier:identifier)
    super
    createLabels
    self
  end

  def render
    @nameLabel.text = @repo.name
    @descriptionLabel.text = @repo.description || 'no description available'
    self.defineAccessoryType
    setFontAwesomeIcon
  end

  private

  def createLabels
    @nameLabel = UILabel.alloc.initWithFrame([[40, 9], [409, 21]])
    @nameLabel.font = UIFont.fontWithName('Roboto-Bold', size: 13)
    @descriptionLabel = UILabel.alloc.initWithFrame([[40, 34], [651, 21]])
    @descriptionLabel.font = UIFont.fontWithName('Roboto-Light', size: 13)
    @fontAwesomeLabel = UILabel.alloc.initWithFrame([[14, 9], [26, 21]])
    @fontAwesomeLabel.font = FontAwesome.fontWithSize(13)

    self.contentView.addSubview(@nameLabel)
    self.contentView.addSubview(@descriptionLabel)
    self.contentView.addSubview(@fontAwesomeLabel)
  end

  def setFontAwesomeIcon
    if @repo.forked?
      icon = 'code-fork'
    elsif @repo.private?
      icon = 'lock'
    else
      icon = 'github'
    end

    @fontAwesomeLabel.text = FontAwesome.icon(icon)
  end

end

class ReposController < UIViewController

  attr_accessor :table, :user, :page

  def init
    super
    @page = 1
    self
  end

  def performHousekeepingTasks
    @table = createTable(cell: RepoCell)
    self.view.addSubview(@table)
  end

  def registerEvents
    'ReposFetched'.add_observer(self, 'displayRepos')
  end

  def viewDidLoad
    performHousekeepingTasks
    createBackButton
    loadHud
  end

  def numberOfSectionsInTableView
    1
  end

  def tableView(tableView, heightForRowAtIndexPath: indexPath)
    67
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = @table.dequeueReusableCellWithIdentifier(RepoCell.reuseIdentifier) || begin
      RepoCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: RepoCell.reuseIdentifier)
    end

    cell.repo = repoForRowAtIndexPath(indexPath)
    cell.render
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    repoController = RepoController.alloc.init
    repoController.repo = repoForRowAtIndexPath(indexPath)
    self.navigationController.pushViewController(repoController, animated: true)
  end

  def displayRepos
    @table.reloadData
    hideHud
  end

  def scrollViewDidScroll(scrollView)
    if scrollView.contentOffset.y + scrollView.frame.size.height == scrollView.contentSize.height
      showHud
      fetchReposForPage(@page)
    end
  end

end

class PersonalReposController < ReposController

  def performHousekeepingTasks
    super
    @user.resetPersonalRepos
    self.navigationItem.title = 'Repositories'
    fetchReposForPage(@page)
    registerEvents
  end

  def fetchReposForPage(page)
    @user.fetchPersonalReposForPage(@page)
    @page += 1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @user.personal_repos.count
  end

  def repoForRowAtIndexPath(indexPath)
    @user.personal_repos[indexPath.row]
  end

end

class StarredReposController < ReposController

  def performHousekeepingTasks
    super
    @user.resetStarredRepos
    self.navigationItem.title = 'Starred Repositories'
    fetchReposForPage(@page)
    registerEvents
  end

  def fetchReposForPage(page)
    @user.fetchStarredReposForPage(@page)
    @page += 1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @user.starred_repos.count
  end

  def repoForRowAtIndexPath(indexPath)
    @user.starred_repos[indexPath.row]
  end

end