class EditProfileController < Formotion::FormController

  def init
    user = CurrentUserManager.sharedInstance

    form = Formotion::Form.new(
      sections: [
        {
          rows: [
            {
              title: 'Name',
              key: 'name',
              type: 'string',
              auto_correction: 'no',
              auto_capitalization: 'none',
              value: user.name,
              selection_style: UITableViewCellSelectionStyleNone
            },
            {
              title: 'Location',
              key: 'location',
              type: 'string',
              auto_correction: 'no',
              auto_capitalization: 'none',
              value: user.location,
              selection_style: UITableViewCellSelectionStyleNone
            },
            {
              title: 'Website',
              key: 'blog',
              type: 'string',
              auto_correction: 'no',
              auto_capitalization: 'none',
              value: user.website,
              selection_style: UITableViewCellSelectionStyleNone
            },
            {
              title: 'Email',
              key: 'email',
              type: 'string',
              auto_correction: 'no',
              auto_capitalization: 'none',
              value: user.email,
              selection_style: UITableViewCellSelectionStyleNone
            },
            {
              title: 'Company',
              key: 'company',
              type: 'string',
              auto_correction: 'no',
              auto_capitalization: 'none',
              value: user.company,
              selection_style: UITableViewCellSelectionStyleNone
            },
            {
              title: 'Submit',
              type: 'submit'
            }
          ]
        }
      ]
    )

    form.on_submit do
      self.view.endEditing(true)
      self.updateProfile
    end
    super.initWithForm(form)
  end

  def viewDidLoad
    super
    createBackButton
    performHousekeepingTasks
    registerEvents
  end

  def performHousekeepingTasks
    self.navigationItem.title = 'Edit Profile'
    self.view.setBackgroundColor(UIColor.whiteColor)
    self.view.backgroundView = nil
  end

  def registerEvents
    'ProfileUpdated'.add_observer(self, 'profileUpdated')
  end

  def updateProfile
    data = @form.render
    CurrentUserManager.sharedInstance.updateProfile(data)
  end

  def profileUpdated
    alert = SIAlertView.alloc.initWithTitle('Alert', andMessage: 'Your profile has been updated')
    alert.addButtonWithTitle('OK', type: 1, handler: nil)
    alert.show
  end

end