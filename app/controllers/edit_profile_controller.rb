class EditProfileController < Formotion::FormController

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
              auto_capitalization: 'none',
              selection_style: UITableViewCellSelectionStyleNone
            },
            {
              title: 'Location',
              key: 'location',
              type: 'string',
              auto_correction: 'no',
              auto_capitalization: 'none',
              selection_style: UITableViewCellSelectionStyleNone
            },
            {
              title: 'Website',
              key: 'website',
              type: 'string',
              auto_correction: 'no',
              auto_capitalization: 'none',
              selection_style: UITableViewCellSelectionStyleNone
            },
            {
              title: 'Email',
              key: 'email',
              type: 'string',
              auto_correction: 'no',
              auto_capitalization: 'none',
              selection_style: UITableViewCellSelectionStyleNone
            },
            {
              title: 'Gravatar Email',
              key: 'gravatar_email',
              type: 'string',
              auto_correction: 'no',
              auto_capitalization: 'none',
              selection_style: UITableViewCellSelectionStyleNone
            },
            {
              title: 'Company',
              key: 'company',
              type: 'string',
              auto_correction: 'no',
              auto_capitalization: 'none',
              selection_style: UITableViewCellSelectionStyleNone
            }
          ]
        }
      ]
    )

    super.initWithForm(form)
  end
  
  def viewDidLoad
    super
    createBackButton
    performHousekeepingTasks
  end
  
  def performHousekeepingTasks
    self.navigationItem.title = 'Edit Profile'
    self.view.setBackgroundColor(UIColor.whiteColor)
    self.view.backgroundView = nil
  end

end