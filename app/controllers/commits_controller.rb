class CommitsController < UIViewController

  attr_accessor :branch, :commits

  def viewDidLoad
    super
    @commits = []
    createBackButton
    performHousekeepingTasks
    registerEvents
    @branch.fetchCommits
  end

  def performHousekeepingTasks
    self.navigationItem.title = 'Commits'
    @table = self.createTable
    self.view.addSubview(@table)
  end

  def registerEvents
    'CommitsFetched'.add_observer(self, 'displayCommits:')
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @commits.count
  end

  def tableView(tableView, heightForRowAtIndexPath: indexPath)
    57
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = @table.dequeueReusableCellWithIdentifier('Cell') || begin
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier: 'Cell')
    end

    commit = @commits[indexPath.row]

    cell.textLabel.font = UIFont.fontWithName('Roboto-Bold', size: 15)
    cell.textLabel.text = commit.message
    cell.detailTextLabel.font = UIFont.fontWithName('Roboto-Light', size: 15)
    cell.detailTextLabel.text = commit.commitedAt.to_s

    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    commitController = CommitController.alloc.init
    commitController.commit = @commits[indexPath.row]
    self.navigationController.pushViewController(commitController, animated: true)
  end

  def displayCommits(notification)
    @commits = notification.object
    @table.reloadData
  end

end