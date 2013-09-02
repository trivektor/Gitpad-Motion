class RepoInfoCell < UITableViewCell

  attr_accessor :repo, :fontAwesomeLabel, :fieldNameLabel, :fieldValueLabel

  PRESENTATION_DATA = {
    0 => {icon: 'info-sign', fieldName: 'Name'},
    1 => {icon: 'link', fieldName: 'Website'},
    2 => {icon: 'eye-open', fieldName: 'Watchers'},
    3 => {icon: 'code-fork', fieldName: 'Forks'},
    4 => {icon: 'terminal', fieldName: 'Language'},
    5 => {icon: 'calendar-empty', fieldName: 'Created'},
    6 => {icon: 'calendar', fieldName: 'Last Updated'},
    7 => {icon: 'user', fieldName: 'Author'},
    8 => {icon: 'warning-sign', fieldName: 'Issues'},
    9 => {icon: 'file-alt', fieldName: 'Readme'},
    10 => {icon: 'ellipsis-horizontal', fieldName: 'Misc'}
  }

  def initWithStyle(style, reuseIdentifier:identifier)
    super
    createLabels
    self
  end

  def createLabels
    @fontAwesomeLabel = UILabel.alloc.initWithFrame([[20, 11], [29, 21]])
    @fontAwesomeLabel.font = FontAwesome.fontWithSize(15)
    @fieldNameLabel = UILabel.alloc.initWithFrame([[67, 11], [105, 21]])
    @fieldNameLabel.font = UIFont.fontWithName('Roboto-Bold', size: 15)
    @fieldValueLabel = UILabel.alloc.initWithFrame([[257, 11], [650, 21]])
    @fieldValueLabel.font = UIFont.fontWithName('Roboto-Light', size: 15)

    self.contentView.addSubview(@fontAwesomeLabel)
    self.contentView.addSubview(@fieldNameLabel)
    self.contentView.addSubview(@fieldValueLabel)
  end

  def renderForIndexPath(indexPath)
    fieldValue = ''

    case indexPath.row
    when 0
      fieldValue = @repo.name
    when 1
      fieldValue = 'Website'
    when 2
      fieldValue = @repo.numWatchers.to_s
    when 3
      fieldValue = @repo.numForks.to_s
    when 4
      fieldValue = @repo.language || 'n/a'
    when 5
      fieldValue = @repo.createdAt
    when 6
      fieldValue = @repo.updatedAt
    when 7
      fieldValue = @repo.owner.name
    when 8
      fieldValue = @repo.hasIssues? ? @repo.numOpenIssues.to_s : 'Issues are disabled for this repo'
    when 9
      fieldValue = 'README'
    when 10
      fieldValue = 'Details'
    end

    @fontAwesomeLabel.text = FontAwesome.icon(PRESENTATION_DATA[indexPath.row][:icon])
    @fieldNameLabel.text = PRESENTATION_DATA[indexPath.row][:fieldName]
    @fieldValueLabel.text = fieldValue
  end

end

class BranchCell < UITableViewCell
end

class RepoController < UIViewController

  attr_accessor :repo, :scrollView, :infoTable, :branchesTable

  def initWithNibName(nibName, bundle:nibBundle)
    super
    self
  end

  def viewDidLoad
    super
    createBackButton
    performHousekeepingTasks
    registerEvents
  end

  def performHousekeepingTasks
    @scrollView = UIScrollView.alloc.initWithFrame(self.view.bounds)
    @scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight

    @infoTable = UITableView.alloc.initWithFrame([[0, 0], [748, 860]], style: UITableViewStyleGrouped)
    @infoTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    @infoTable.delegate = self
    @infoTable.dataSource = self
    @infoTable.scrollEnabled = false
    @infoTable.registerClass(RepoInfoCell, forCellReuseIdentifier: RepoInfoCell.reuseIdentifier)
    @infoTable.backgroundView = nil

    @branchesTable = UITableView.alloc.initWithFrame([[0, 860], [748, 140]], style: UITableViewStyleGrouped)
    @branchesTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    @branchesTable.delegate = self
    @branchesTable.dataSource = self
    @branchesTable.scrollEnabled = false
    @branchesTable.registerClass(BranchCell, forCellReuseIdentifier: BranchCell.reuseIdentifier)

    @scrollView.addSubview(@infoTable)
    @scrollView.addSubview(@branchesTable)

    self.view.addSubview(@scrollView)
    self.view.setBackgroundColor(UIColor.whiteColor)
  end

  def registerEvents
    center = NSNotificationCenter.defaultCenter

    center.addObserver(self, selector: 'displayRepoInfo:', name: 'RepoInfoFetched', object: nil)
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    if tableView == @infoTable
      11
    else
      2
    end
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    if tableView == @infoTable
      cellForInfoTableAtIndexPath(indexPath)
    else
      cellForBranchesTableAtIndexPath(indexPath)
    end
  end

  def displayRepoInfo(notification)
    @repo = notification.object
    @infoTable.reloadData
  end

  private

  def cellForInfoTableAtIndexPath(indexPath)
    cell = @infoTable.dequeueReusableCellWithIdentifier(RepoInfoCell.reuseIdentifier) || begin
      RepoInfoCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: RepoInfoCell.reuseIdentifier)
    end

    cell.repo = @repo
    cell.renderForIndexPath(indexPath)

    cell
  end

  def cellForBranchesTableAtIndexPath(indexPath)
    cell = @branchesTable.dequeueReusableCellWithIdentifier('Cell') || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: 'Cell')
    end

    cell
  end

end