class FeedbackController < Formotion::FormController

  def init
    form = Formotion::Form.new(
      sections: [
        {
          rows: [
            mergeRowOptions(
              title: 'Name',
              key: 'name',
              type: 'string',
            ),
            mergeRowOptions(
              title: 'Email',
              key: 'email',
              type: 'email',
            ),
            mergeRowOptions(
              title: 'Message',
              key: 'message',
              type: 'text',
              row_height: 400
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

    form.on_submit { self.sendFeedback }
    super.initWithForm(form)
  end

  def viewDidLoad
    super
    performHousekeepingTasks
  end

  def performHousekeepingTasks
    super
    self.navigationItem.title = 'Feedback'
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
      alert = SIAlertView.alloc.initWithTitle('Oops', andMessage: 'Please enter all required fields')
      alert.addButtonWithTitle('OK', type: 1, handler: nil)
      alert.show
    else
      Feedback.sendToServer(name: name, from: from, text: text)
    end
  end

  def postFeedbackHandler
    alert = SIAlertView.alloc.initWithTitle('Oops', andMessage: 'Feedback has been sent successfully')
    alert.addButtonWithTitle('OK', type: 1, handler: nil)
    alert.show
  end

end