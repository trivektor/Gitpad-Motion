UITableViewCell.class_eval do

  def self.reuseIdentifier
    to_s
  end

  def defineAccessoryType
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator
  end

end