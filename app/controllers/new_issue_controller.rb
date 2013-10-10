class NewIssueController < Formotion::FormController

  attr_accessor :repo

  def init
    form = Formotion::Form.new(
      sections: [
        {
          rows: [
            mergeRowOptions(
              title: 'Title',
              key: 'title',
              type: 'string',
            ),
            mergeRowOptions(
              title: 'Description',
              key: 'body',
              type: 'text',
              row_height: 500
            )
          ]
        },
        {
          rows: [
            {
              title: 'Submit',
              type: 'submit'
            }
          ]
        }
      ]
    )

    form.on_submit { createIssue }
    super.initWithForm(form)
  end

  def viewDidLoad
    super
    loadHud
    hideHud
    createBackButton
    performHousekeepingTasks
    registerEvents
  end

  def performHousekeepingTasks
    super
    self.navigationItem.title = 'New Issue'
  end

  def registerEvents
    'NewIssueCreated'.add_observer(self, 'postIssueCreateHandler')
  end

  def createIssue
    self.view.endEditing(true)
    data = @form.render
    showHud
    Issue.createNew(data.merge(repo: @repo))
  end

  def postIssueCreateHandler
    alert = SIAlertView.alloc.initWithTitle('Alert', andMessage: 'Issue has been created')
    alert.addButtonWithTitle('OK', type: 1, handler: nil)
    alert.show
    hideHud
  end

end