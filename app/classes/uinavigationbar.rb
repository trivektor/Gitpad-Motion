class UINavigationBar

  # http://stackoverflow.com/questions/9935119/add-uinavigationbar-shadow-application-wide
  def willMoveToWindow(window)
    super(window)
    applyDefaultStyle
  end

  def applyDefaultStyle
    self.layer.shadowOpacity = 0
    self.clipsToBounds = true

    # http://stackoverflow.com/questions/6815034/how-to-change-the-border-color-below-the-navigation-bar
    navBorder = UIView.alloc.initWithFrame([[0, self.frame.size.height-1], [self.frame.size.width, 1]])
    navBorder.backgroundColor = '#ccc'.uicolor
    navBorder.opaque = true
    self.addSubview(navBorder)
  end

end