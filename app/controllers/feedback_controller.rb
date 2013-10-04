class FeedbackController < Formotion::FormController

  def init
    form = Formotion::Form.new(
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

    form.on_submit { self.sendFeedback }
    super.initWithForm(form)
  end

  def viewDidLoad
    super
    performHousekeepingTasks
  end

  def performHousekeepingTasks
    self.navigationItem.title = 'Feedback'
    self.view.setBackgroundColor(UIColor.whiteColor)
    self.view.backgroundView = nil
  end

  def registerEvents
    'FeedbackSucceed'.add_observer(self, 'postFeedbackHandler')
  end

  def sendFeedback
    data = @form.render

    name = data['name']
    from = data['email']
    text = data['message']

    if name.length == 0 || from.length == 0 || text.length == 0
      UIAlertView.alert 'Please enter all required fields'
    else
      Feedback.sendToServer(name: name, from: from, text: text)
    end
  end

  def postFeedbackHandler
    UIAlertView.all 'Feedback has been sent successfully'
  end

end