class MasterControllerCell < UITableViewCell

  attr_accessor :iconLabel, :textLabel

  def initWithStyle(style, reuseIdentifier:identifier)
    super
    self.createLabels
    self
  end

  def createLabels
    @iconLabel = UILabel.alloc.initWithFrame([[15, 9], [25, 25]])
    @iconLabel.textColor = UIColor.whiteColor
    @iconLabel.backgroundColor = UIColor.clearColor

    @textLabel = UILabel.alloc.initWithFrame([[51, 11], [243, 21]])
    @textLabel.textColor = UIColor.whiteColor
    @textLabel.backgroundColor = UIColor.clearColor
    @textLabel.font = UIFont.fontWithName('Roboto-Medium', size:13)
    @textLabel.text = 'text'

    self.contentView.addSubview(@iconLabel)
    self.contentView.addSubview(@textLabel)
  end

  def renderForIndexPath(indexPath)
    @iconLabel.font = FontAwesome.fontWithSize(15)

    case indexPath.section
    when 1
      @iconLabel.text = FontAwesome.icon('rss')
    when 2
      case indexPath.row
      when 0
        @iconLabel.text = FontAwesome.icon('github')
      when 1
        @iconLabel.text = FontAwesome.icon('star-empty')
      when 2
        @iconLabel.text = FontAwesome.icon('plus-sign')
      end
    when 3
      case indexPath.row
      when 0
        @iconLabel.text = FontAwesome.icon('code')
      when 1
        @iconLabel.text = FontAwesome.icon('search')
      when 2
        @iconLabel.text = FontAwesome.icon('bullhorn')
      when 3
        @iconLabel.text = FontAwesome.icon('envelope')
      when 4
        @iconLabel.text = FontAwesome.icon('off')
      when 5
        @iconLabel.text = FontAwesome.icon('legal')
      end
    end
  end

  def self.reuseIdentifier
    to_s
  end

end

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
    @table.registerClass(MasterControllerCell, forCellReuseIdentifier:MasterControllerCell.reuseIdentifier)
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
    cell = tableView.dequeueReusableCellWithIdentifier(MasterControllerCell.reuseIdentifier)

    if !cell
      cell = MasterControllerCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:MasterControllerCell.reuseIdentifier)
    end

    cell.renderForIndexPath(indexPath)
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