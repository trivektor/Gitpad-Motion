class IssuesController < UIViewController

  attr_accessor :repo

  def viewDidLoad
    super
    createBackButton
    createNewIssueButton
    performHousekeepingTasks
    registerEvents
    @repo.fetchIssues
  end

  def performHousekeepingTasks
    self.navigationItem.title = "#{repo.name}'s issues"

    @table = self.createTable
    self.view.addSubview(@table)
  end

  def registerEvents
    'RepoIssuesFetched'.add_observer(self, 'displayIssues:')
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @repo.issues.count
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = @table.dequeueReusableCellWithIdentifier('Cell') || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier: 'Cell')
    end

    issue = @repo.issues[indexPath.row]

    cell.textLabel.font = UIFont.fontWithName('Roboto-Medium', size: 15)
    cell.textLabel.text = issue.title
    cell.detailTextLabel.font = UIFont.fontWithName('Roboto-Light', size: 15)
    cell.detailTextLabel.text = issue.relativeCreatedAt
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    issueController = IssueController.alloc.init
    issueController.issue = @repo.issues[indexPath.row]
    self.navigationController.pushViewController(issueController, animated: true)
  end

  def displayIssues(notification)
    @table.reloadData
  end

  def createNewIssueButton
    newIssueBtn = createFontAwesomeButton(
      icon: 'exclamation-sign',
      touchHandler: 'createNewIssue'
    )
    self.navigationItem.rightBarButtonItem = newIssueBtn
  end

  def createNewIssue
    @newIssueController = NewIssueController.alloc.init
    @newIssueController.repo = @repo
    self.navigationController.pushViewController(@newIssueController, animated: true)
  end

end