class NewRepoController < Formotion::FormController

  def viewDidLoad
    super
    createBackButton
    performHousekeepingTasks
  end

  def performHousekeepingTasks
    self.navigationItem.title = 'New Repository'
    self.view.setBackgroundColor(UIColor.whiteColor)
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
              placeholder: 'e.g: Rails',
              auto_correction: 'no',
              auto_capitalization: 'none'
            },
            {
              title: 'Description',
              key: 'description',
              type: 'string',
              auto_correction: 'no',
              auto_capitalization: 'none'
            }
          ]
        },
        {
          title: 'Access Control',
          select_one: true,
          rows: [
            {
              title: 'Public',
              key: 'public',
              type: 'check',
              value: true
            },
            {
              title: 'Private',
              key: 'private',
              type: 'check'
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
    })
  end

end