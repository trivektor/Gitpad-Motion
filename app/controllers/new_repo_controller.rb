class NewRepoController < Formotion::FormController

  def init
    form = Formotion::Form.new(
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
            },
            {
              title: 'Home page',
              key: 'homepage',
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
              key: 'public',
              type: 'check',
              value: false
            }
          ]
        },
        {
          title: 'Auto init',
          rows: [
            {
              title: 'Initialize this repository with a README',
              key: 'auto_init',
              type: 'switch'
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

    form.on_submit { self.createRepo }
    super.initWithForm(form)
  end

  def viewDidLoad
    super
    performHousekeepingTasks
  end

  def performHousekeepingTasks
    self.navigationItem.title = 'New Repository'
    self.view.setBackgroundColor(UIColor.whiteColor)
    self.view.backgroundView = nil
  end

  def createRepo
    data = @form.render

    Repo.createNew(
      name: data['name'],
      description: data['description'],
      homepage: data['homepage'],
      private: !data['public'],
      auto_init: data['auto_init']
    )
  end

end