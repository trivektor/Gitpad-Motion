class NewIssueController < Formotion::FormController
  
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
    
    form.on_submit {  }
    super.initWithForm(form)
  end
  
  def viewDidLoad
    super
    createBackButton
    performHousekeepingTasks
    registerEvents
  end
  
  def performHousekeepingTasks
    super
    self.navigationItem.title = 'New Issue'
  end
  
  def registerEvents
  end
  
end