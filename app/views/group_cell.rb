class GroupCell < UITableViewCell

  def rmq_build
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    q = rmq(self.contentView)
    @name = q.build(self.textLabel, :cell_label).get

    if self.respondsToSelector('layoutMargins')
      self.layoutMargins = UIEdgeInsetsZero
    end
  end

  def update(group)
    @name.text = group['name']
  end

end
