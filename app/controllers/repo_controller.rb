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
    self.backgroundColor = UIColor.whiteColor
  end

  def renderForIndexPath(indexPath)
    fieldValue = ''

    case indexPath.row
    when 0
      fieldValue = @repo.name
    when 1
      fieldValue = @repo.homepage || 'n/a'
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
      fieldValue = @repo.owner.login
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

class RepoController < UIViewController

  attr_accessor :repo, :scrollView, :infoTable, :branchesTable, :branches

  def initWithNibName(nibName, bundle:nibBundle)
    super
    @branches = []
    self
  end

  def viewDidLoad
    super
    createBackButton
    performHousekeepingTasks
    registerEvents
    @repo.fetchFullInfo
  end

  def performHousekeepingTasks
    self.navigationItem.title = @repo.name

    @scrollView = UIScrollView.alloc.initWithFrame(self.view.bounds)
    @scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    @scrollView.scrollEnabled = true

    @infoTable = UITableView.alloc.initWithFrame([[0, 0], [748, 870]], style: UITableViewStyleGrouped)
    @infoTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    @infoTable.delegate = self
    @infoTable.dataSource = self
    @infoTable.scrollEnabled = false
    @infoTable.registerClass(RepoInfoCell, forCellReuseIdentifier: RepoInfoCell.reuseIdentifier)
    @infoTable.backgroundView = nil

    branchesLabel = UILabel.alloc.initWithFrame([[0, 550], [1024, 20]])
    branchesLabel.font = UIFont.fontWithName('Roboto-Bold', size: 15)
    branchesLabel.textAlignment = NSTextAlignmentCenter
    branchesLabel.text = 'Branches'

    @branchesTable = UITableView.alloc.initWithFrame([[0, 570], [748, 140]], style: UITableViewStyleGrouped)
    @branchesTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    @branchesTable.delegate = self
    @branchesTable.dataSource = self
    @branchesTable.scrollEnabled = false
    @branchesTable.backgroundView = nil

    @scrollView.addSubview(@infoTable)
    @scrollView.addSubview(branchesLabel)
    @scrollView.addSubview(@branchesTable)

    self.view.addSubview(@scrollView)
    self.view.setBackgroundColor(UIColor.whiteColor)
  end

  def registerEvents
    center = NSNotificationCenter.defaultCenter

    center.addObserver(self, selector: 'displayRepoInfo:', name: 'RepoInfoFetched', object: nil)
    center.addObserver(self, selector: 'displayBranches:', name: 'RepoBranchesFetched', object: nil)
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    tableView == @infoTable ? 11 : @branches.count
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    tableView == @infoTable ? cellForInfoTableAtIndexPath(indexPath) : cellForBranchesTableAtIndexPath(indexPath)
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    if tableView == @branchesTable
      repoTreeController = RepoTreeController.alloc.init
      repoTreeController.branch = @branches[indexPath.row]
      repoTreeController.repo = @repo
      self.navigationController.pushViewController(repoTreeController, animated: true)
    else
      case indexPath.row
      when 10
        repoMiscController = RepoMiscController.alloc.init
        self.presentSemiModalViewController(repoMiscController)
      end
    end
  end

  def displayRepoInfo(notification)
    @repo = notification.object
    @infoTable.reloadData
    @repo.fetchBranches
  end

  def displayBranches(notification)
    puts 'displaying branches'
    @branches = notification.object
    @branchesTable.setFrame([[0, 570], [self.view.frame.size.width, @branches.count*44 + 100]])
    @branchesTable.reloadData
    adjustFrameHeight
  end

  private

  def adjustFrameHeight
    @scrollView.setContentSize(self.view.frame.size)
    height = 0
    @scrollView.subviews.each { |subview| height += subview.frame.size.height }

    @scrollView.setContentSize(CGSizeMake(self.view.frame.size.width, height + 35))
  end

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

    branch = @branches[indexPath.row]
    cell.textAlignment = NSTextAlignmentCenter
    cell.textLabel.font = UIFont.fontWithName('Roboto-Light', size: 15)
    cell.textLabel.text = branch.name
    cell.defineAccessoryType
    cell.backgroundColor = UIColor.whiteColor
    cell
  end

end