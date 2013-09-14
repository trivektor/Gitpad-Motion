class FeedbackController < Formotion::FormController
  
  def viewDidLoad
    super
    performHousekeepingTasks
  end

  def performHousekeepingTasks
    self.navigationItem.title = 'Feedback'
    self.view.setBackgroundColor(UIColor.whiteColor)
    self.view.backgroundView = nil
  end
  
  def self.form
    Formotion::Form.new({
      sections: [
        {
          rows: [
            {
              title: 'Name',
              key: 'name',
              type: 'string',
              auto_correction: 'no',
              auto_capitalization: 'none'
            },
            {
              title: 'Email',
              key: 'email',
              type: 'email',
              auto_correction: 'no',
              auto_capitalization: 'none'
            },
            {
              title: 'Message',
              key: 'message',
              type: 'string',
              auto_correction: 'no',
              auto_capitalization: 'none'
            }
          ]
        }
      ]
    })
  end
  
end