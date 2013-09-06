class RepoMiscController < TDSemiModalViewController

  def initWithNibName(nibName, bundle: nibBundle)
    super
    self
  end

  def viewDidLoad
    setupOptions
  end

  def setupOptions
    @subView = UIView.alloc.initWithFrame([[0, 678], [1044, 70]])
    @subView.backgroundColor = UIColor.blackColor

    @contributorsBtn = createButton(
      buttonFrame: [[20, 12], [199, 44]],
      labelFrame: [[31, 11], [110, 21]],
      icon: 'group',
      textColor: UIColor.alizarinColor,
      labelName: 'Contributors'
    )

    @commitActivityBtn = createButton(
      buttonFrame: [[258, 12], [230, 44]],
      labelFrame: [[31, 11], [150, 21]],
      icon: 'bar-chart',
      textColor: UIColor.peterRiverColor,
      labelName: 'Commits Activity'
    )

    @punchCardBtn = createButton(
      buttonFrame: [[523, 12], [170, 44]],
      labelFrame: [[31, 11], [90, 21]],
      icon: 'time',
      textColor: UIColor.emerlandColor,
      labelName: 'Punch Card'
    )

    @subView.addSubview(@contributorsBtn)
    @subView.addSubview(@commitActivityBtn)
    @subView.addSubview(@punchCardBtn)

    self.view.addSubview(@subView)
  end

  def createButton(options)
    btn = UIButton.alloc.initWithFrame(options[:buttonFrame], style: UIButtonTypeRoundedRect)
    btn.font = FontAwesome.fontWithSize(15)
    btn.setTitle(FontAwesome.icon(options[:icon]), forState: UIControlStateNormal)
    btn.setTitle(FontAwesome.icon(options[:icon]), forState: UIControlEventTouchDown)
    btn.setContentHorizontalAlignment(UIControlContentHorizontalAlignmentLeft)
    btn.setTitleColor(options[:textColor], forState: UIControlStateNormal)

    label = UILabel.alloc.initWithFrame(options[:labelFrame])
    label.font = UIFont.fontWithName('Roboto-Bold', size: 15)
    label.textColor = options[:textColor]
    label.text = options[:labelName]

    btn.addSubview(label)
    btn
  end

end