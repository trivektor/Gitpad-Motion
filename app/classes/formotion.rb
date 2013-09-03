# Suggested work around https://github.com/clayallsopp/formotion/issues/32#issuecomment-9461540
module Formotion
  class Form < Formotion::Base
    def tableView(tableView, willDisplayCell: cell, forRowAtIndexPath: indexPath)
      cell.textLabel.font = UIFont.fontWithName('Roboto-Bold', size: 15)
    end
  end
end