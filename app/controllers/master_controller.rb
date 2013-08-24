# class MasterControllerCell < UITableViewCell
#
#   def initialize
#   end
#
# end

class MasterController < UIViewController

  attr_accessor :user, :table

  def initWithNibName(nibName, bundle:nibBundle)
    super
    self
  end

  def viewDidLoad
    super
    performHousekeepingTasks
    registerEvents
  end

  def performHousekeepingTasks
    @table = UITableView.alloc.initWithFrame(self.view.bounds, style:UITableViewStylePlain)
    @table.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    @table.delegate = self
    @table.dataSource = self
    @table.setBackgroundColor(UIColor.colorWithRed(55/255.0, green:55/255.0, blue:55/255.0, alpha:1.0))
    @table.setSeparatorColor(UIColor.clearColor)
    self.view.addSubview(@table)
  end

  def registerEvents
    NSNotificationCenter.defaultCenter.addObserver(self, selector:'toggleViewDeck', name:'ToggleViewDeck', object:nil)
  end

  def numberOfSectionsInTableView(tableView)
    4
  end

  def tableView(tableView, numberOfRowsInSection:section)
    case section
    when 0
      1
    when 1
      1
    when 2
      3
    when 3
      6
    else
      0
    end
  end

  def tableView(tableView, heightForHeaderInSection:section)
    25
  end

  def tableView(tableView, viewForHeaderInSection:section)
    headerLabel = UILabel.alloc.initWithFrame(CGRectMake(8, 1, 300, 25))
    headerLabel.backgroundColor = UIColor.clearColor
    headerLabel.text = self.tableView(tableView, titleForHeaderInSection:section)
    headerLabel.textColor = UIColor.colorWithRed(179/255.0, green:179/255.0, blue:179/255.0, alpha:1.0)
    headerLabel.font = UIFont.fontWithName('Arial-BoldMT', size:12.0)
    backgroundView = UIView.alloc.initWithFrame(CGRectMake(0, 0, 300, 25))
    backgroundView.backgroundColor = UIColor.colorWithRed(49/255.0, green:49/255.0, blue:49/255.0, alpha:0.9)
    backgroundView.addSubview(headerLabel)
    backgroundView
  end

  def tableView(tableView, titleForHeaderInSection:section)
    case section
    when 0
      'Profile'
    when 1
      'News Feed'
    when 2
      'Repositories'
    when 3
      'Others'
    end
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    @cellIdentifier ||= 'Cell'
    cell = tableView.dequeueReusableCellWithIdentifier(@cellIdentifier)

    if !cell
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@cellIdentifier)
    end

    cell
    # if indexPath.row == 0 || indexPath.row == 1
    #
    # else
    # end
  end

  private

  def displayAvatarAndUsername
    # TO BE IMPLEMENTED
  end

  def toggleViewDeck
    # TO BE IMPLEMENTED
  end

end