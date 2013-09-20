class CommitsController < UIViewController

  attr_accessor :branch, :commits, :page

  def viewDidLoad
    super
    @page = 1
    createBackButton
    performHousekeepingTasks
    registerEvents
    fetchCommitsForPage(@page)
  end

  def performHousekeepingTasks
    self.navigationItem.title = 'Commits'
    @table = self.createTable
    self.view.addSubview(@table)
  end

  def registerEvents
    'CommitsFetched'.add_observer(self, 'displayCommits')
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @branch.commits.count
  end

  def tableView(tableView, heightForRowAtIndexPath: indexPath)
    57
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = @table.dequeueReusableCellWithIdentifier('Cell') || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier: 'Cell')
    end

    commit = @branch.commits[indexPath.row]

    cell.textLabel.font = UIFont.fontWithName('Roboto-Bold', size: 13)
    cell.textLabel.text = commit.message
    cell.detailTextLabel.font = UIFont.fontWithName('Roboto-Light', size: 13)
    cell.detailTextLabel.text = commit.relativeCommitedAt

    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    commitController = CommitController.alloc.init
    commitController.commit = @branch.commits[indexPath.row]
    self.navigationController.pushViewController(commitController, animated: true)
  end

  def displayCommits
    @table.reloadData
  end

  def fetchCommitsForPage(page=1)
    @branch.fetchCommits(@page)
    @page += 1
  end

  def scrollViewDidScroll(scrollView)
    if scrollView.contentOffset.y + scrollView.frame.size.height == scrollView.contentSize.height
      fetchCommitsForPage(@page)
    end
  end

end