class RepoMiscController < TDSemiModalViewController

  DEFAULT_ICON_FONT_SIZE = 20

  def initWithNibName(nibName, bundle: nibBundle)
    super
    self
  end

  def viewDidLoad
    setupOptions
  end

  def setupOptions
    @subView = UIView.alloc.initWithFrame([[0, 678], [1044, 70]])
    @subView.backgroundColor = :white.uicolor

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

    @closeBtn = createButton(
      buttonFrame: [[968, 10], [47, 44]],
      labelFrame: nil,
      icon: 'remove-circle',
      textColor: UIColor.pomegranateColor,
      iconFontSize: 26
    )

    @closeBtn.addTarget(self, action: 'closeMiscModal', forControlEvents: UIControlEventTouchUpInside)

    @subView.addSubview(@contributorsBtn)
    @subView.addSubview(@commitActivityBtn)
    @subView.addSubview(@punchCardBtn)
    @subView.addSubview(@closeBtn)

    self.view.setBackgroundColor(:black.uicolor(0.6))
    self.view.addSubview(@subView)
  end

  def createButton(options)
    btn = UIButton.alloc.initWithFrame(options[:buttonFrame], style: UIButtonTypeRoundedRect)
    btn.font = FontAwesome.fontWithSize(options[:iconFontSize] || DEFAULT_ICON_FONT_SIZE)
    btn.setTitle(FontAwesome.icon(options[:icon]), forState: UIControlStateNormal)
    btn.setTitle(FontAwesome.icon(options[:icon]), forState: UIControlEventTouchDown)
    btn.setContentHorizontalAlignment(UIControlContentHorizontalAlignmentLeft)
    btn.setTitleColor(options[:textColor], forState: UIControlStateNormal)

    unless options[:labelFrame].nil?
      label = UILabel.alloc.initWithFrame(options[:labelFrame])
      label.font = UIFont.fontWithName('Roboto-Bold', size: 16)
      label.textColor = options[:textColor]
      label.text = options[:labelName]
      label.backgroundColor = UIColor.clearColor

      btn.addSubview(label)
    end

    btn
  end

  def closeMiscModal
    NSNotificationCenter.defaultCenter.postNotificationName('CloseRepoMiscModal', object: nil);
  end

end