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
              auto_capitalization: 'none',
              selection_style: UITableViewCellSelectionStyleNone
            },
            {
              title: 'Description',
              key: 'description',
              type: 'string',
              auto_correction: 'no',
              auto_capitalization: 'none',
              selection_style: UITableViewCellSelectionStyleNone
            },
            {
              title: 'Home page',
              key: 'homepage',
              type: 'string',
              auto_correction: 'no',
              auto_capitalization: 'none',
              selection_style: UITableViewCellSelectionStyleNone
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

    form.on_submit do
      self.view.endEditing(true)
      self.createRepo
    end
    super.initWithForm(form)
  end

  def viewDidLoad
    super
    performHousekeepingTasks
    registerEvents
  end

  def viewDidAppear(animated)
    super
    loadHud
    hideHud
  end

  def performHousekeepingTasks
    self.navigationItem.title = 'New Repository'
    self.view.setBackgroundColor(UIColor.whiteColor)
    self.view.backgroundView = nil
  end

  def registerEvents
    'RepoCreated'.add_observer(self, 'handleRepoPostCreation')
  end

  def createRepo
    data = @form.render

    if data['name'].length == 0
      alert = SIAlertView.alloc.initWithTitle('Oops', andMessage: 'Please enter a name for this repo')
      alert.addButtonWithTitle('OK', type: 1, handler: nil)
      alert.transitionStyle = 0
      alert.show
      return
    end

    showHud

    Repo.createNew(
      name: data['name'].to_s,
      description: data['description'].to_s,
      homepage: data['homepage'].to_s,
      private: !!data['public'],
      auto_init: !!data['auto_init']
    )
  end

  def handleRepoPostCreation
    UIAlertView.alert('Repo has been created')
    hideHud
  end

end