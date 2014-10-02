class MemberCell < UITableViewCell

  def rmq_build
    q = rmq(self.contentView)
    @name = q.build(self.textLabel, :cell_label).get

    if self.respondsToSelector('layoutMargins')
      self.layoutMargins = UIEdgeInsetsZero
    end
  end

  def update(user)
    @name.text = user['name']
  end

end
