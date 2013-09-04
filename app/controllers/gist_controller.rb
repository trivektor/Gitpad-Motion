class GistStatCell < UITableViewCell

  attr_accessor :fieldNameLabel, :fieldValueLabel, :gist

  PRESENTATION_DATA = {
    0 => {fieldName: 'Files'},
    1 => {fieldName: 'Forks'},
    2 => {fieldName: 'Comments'}
  }

  def initWithStyle(style, reuseIdentifier:identifier)
    super
    createLabels
    self
  end

  def createLabels
    self.backgroundColor = UIColor.whiteColor
    @fieldNameLabel = UILabel.alloc.initWithFrame([[20, 11], [108, 21]])
    @fieldNameLabel.font = UIFont.fontWithName('Roboto-Bold', size: 15)

    @fieldValueLabel = UILabel.alloc.initWithFrame([[169, 11], [650, 21]])
    @fieldValueLabel.font = UIFont.fontWithName('Roboto-Light', size: 15)

    self.contentView.addSubview(@fieldNameLabel)
    self.contentView.addSubview(@fieldValueLabel)
  end

  def renderForIndexPath(indexPath)
    @fieldNameLabel.text = PRESENTATION_DATA[indexPath.row][:fieldName]

    if indexPath.row == 0
      @fieldValueLabel.text = @gist.numFiles.to_s
    elsif indexPath.row == 1
      @fieldValueLabel.text = @gist.numForks.to_s
    else
      @fieldValueLabel.text = @gist.numComments.to_s
    end
  end

end

class GistController < UIViewController

  attr_accessor :scrollView, :gist, :statsTable, :filesTable, :files

  def initWithNibName(nibName, bundle:nibBundle)
    super
    self
  end

  def viewDidLoad
    super
    createBackButton
    performHousekeepingTasks
    registerEvents
    @gist.fetchStats
  end

  def performHousekeepingTasks
    self.navigationItem.title = "gist:#{@gist.id}"

    @scrollView = UIScrollView.alloc.initWithFrame(self.view.bounds)
    @scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    @scrollView.scrollEnabled = true

    @statsTable = UITableView.alloc.initWithFrame([[0, 0], [748, 550]], style: UITableViewStyleGrouped)
    @statsTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    @statsTable.delegate = self
    @statsTable.dataSource = self
    @statsTable.scrollEnabled = false
    @statsTable.registerClass(GistStatCell, forCellReuseIdentifier: GistStatCell.reuseIdentifier)
    @statsTable.backgroundView = nil

    @scrollView.addSubview(@statsTable)

    self.view.addSubview(@scrollView)
    self.view.setBackgroundColor(UIColor.whiteColor)
  end

  def registerEvents
    center = NSNotificationCenter.defaultCenter

    center.addObserver(self, selector: 'displayGistStats:', name: 'GistStatsFetched', object: nil)
  end

  def displayGistStats(notification)
    @gist = notification.object
    @statsTable.reloadData
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    tableView == @statsTable ? 3 : 0
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    tableView == @statsTable ? cellForStatsTableAtIndexPath(indexPath) : cellForFilesTableAtIndexPath(indexPath)
  end

  def cellForStatsTableAtIndexPath(indexPath)
    cell = @statsTable.dequeueReusableCellWithIdentifier(GistStatCell.reuseIdentifier) || begin
      GistStatCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: GistStatCell.reuseIdentifier)
    end

    cell.gist = @gist
    cell.renderForIndexPath(indexPath)

    cell
  end

  def cellForFilesTableAtIndexPath(indexPath)
  end
end