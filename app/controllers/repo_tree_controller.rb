class RepoTreeCell < UITableViewCell

  attr_accessor :iconLabel, :fileNameLabel, :node

  def initWithStyle(style, reuseIdentifier:identifier)
    super
    createLabels
    self
  end

  def createLabels
    @iconLabel = UILabel.alloc.initWithFrame([[19, 11], [24, 21]])
    @iconLabel.font = FontAwesome.fontWithSize(15)
    @fileNameLabel = UILabel.alloc.initWithFrame([[50, 11], [954, 21]])
    @fileNameLabel.font = UIFont.fontWithName('Roboto-Light', size: 15)

    self.contentView.addSubview(@iconLabel)
    self.contentView.addSubview(@fileNameLabel)
  end

  def render
    @iconLabel.text = @node.tree? ? FontAwesome.icon('folder-close') : FontAwesome.icon('file')
    @fileNameLabel.text = @node.path
    self.defineAccessoryType
  end

end

class RepoTreeController < UIViewController

  attr_accessor :nodes, :node, :branch, :repo, :table

  def initWithNibName(nibName, bundle:nibBundle)
    super
    @nodes = []
    self
  end

  def viewWillAppear(animated)
    unless @table.nil?
      fetchData
    end
  end

  def viewDidLoad
    super
    createBackButton
    createCommitsButton
    performHousekeepingTasks
    registerEvents
    fetchData
  end

  def performHousekeepingTasks
    self.navigationItem.title = node.nil? ? @branch.name : @node.path

    @table = UITableView.alloc.initWithFrame(self.view.bounds, style: UITableViewStylePlain)
    @table.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    @table.delegate = self
    @table.dataSource = self
    @table.scrollEnabled = true
    @table.registerClass(RepoTreeCell, forCellReuseIdentifier: RepoTreeCell.reuseIdentifier)
    @table.backgroundView = nil

    self.view.addSubview(@table)
    self.view.setBackgroundColor(UIColor.whiteColor)
  end

  def registerEvents
    NSNotificationCenter.defaultCenter.addObserver(self, selector: 'displayTree:', name: 'TreeFetched', object: nil)
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @nodes.count
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = @table.dequeueReusableCellWithIdentifier(RepoTreeCell.reuseIdentifier) || begin
      RepoTreeCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: RepoTreeCell.reuseIdentifier)
    end

    cell.node = @nodes[indexPath.row]
    cell.render
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    selectedNode = @nodes[indexPath.row]

    if selectedNode.blob?
      rawFileController = RawFileController.alloc.init
      rawFileController.repo = @repo
      rawFileController.branch = @branch
      rawFileController.fileName = selectedNode.path

      self.navigationController.pushViewController(rawFileController, animated: true)
    else
      repoTreeController = RepoTreeController.alloc.init
      repoTreeController.branch = @branch
      repoTreeController.node = selectedNode
      repoTreeController.repo = @repo

      self.navigationController.pushViewController(repoTreeController, animated: true)
    end
  end

  def fetchData
    @node.nil? ? @repo.fetchTopLayerForBranch(@branch) : @node.fetchTree
  end

  def displayTree(notification)
    @nodes = notification.object
    @table.reloadData
  end

  def showBranchCommits
    commitsController = CommitsController.alloc.init
    commitsController.branch = @branch
    self.navigationController.pushViewController(commitsController, animated: true)
  end

  def createCommitsButton
    commitBtn = UIBarButtonItem.titled(FontAwesome.icon('cloud-upload')) do
      self.showBranchCommits
    end

    commitBtn.setTitleTextAttributes({
      UITextAttributeFont => FontAwesome.fontWithSize(20),
      UITextAttributeTextColor => :black.uicolor
    }, forState: UIControlStateNormal)

    self.navigationItem.setRightBarButtonItem(commitBtn)
  end

end