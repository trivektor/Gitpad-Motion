class LanguagesPieChartController < UIViewController

  attr_accessor :distributions

  COLORS = [
    '#FC386E',
    '#FBCB4C',
    '#F6F083',
    '#6ECB5D',
    '#AA5AD1',
    '#186FD0',
    '#37A6EF',
    '#4FDAFA',
    '#1B1D2B',
    '#9CA7B4'
  ]

  def viewDidLoad
    super
    createBackButton
    performHousekeepingTasks
    @pieChart.reloadData
  end

  def performHousekeepingTasks
    self.navigationItem.title = 'Languages Distribution'

    view = UIView.alloc.initWithFrame(self.view.bounds)
    view.backgroundColor = UIColor.whiteColor
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight

    @pieChart = XYPieChart.alloc.initWithFrame([[340, 100], [400, 400]])
    @pieChart.pieRadius = 200
    @pieChart.delegate = self
    @pieChart.dataSource = self
    view.addSubview(@pieChart)

    self.view.addSubview(view)
  end

  def numberOfSlicesInPieChart(pieChart)
    @distributions.count
  end

  def pieChart(pieChart, valueForSliceAtIndex: index)
    @distributions[index][:percentage]
  end

  def pieChart(pieChart, colorForSliceAtIndex: index)
    COLORS[index].uicolor
  end

  def pieChart(pieChart, textForSliceAtIndex: index)
    @distributions[index][:name]
  end

end