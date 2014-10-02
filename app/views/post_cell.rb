class PostCell < UITableViewCell

  def rmq_build
    q = rmq(self.contentView)
    # @user_name_label = q.build(self.textLabel, :user_name_label).get
    @user_name_label = q.append(UILabel, :user_name_label).get
    @text = q.append(UILabel, :text).get

    if self.respondsToSelector('layoutMargins')
      self.layoutMargins = UIEdgeInsetsZero
    end
  end

  def update(post)
    @user_name_label.text = post['user']['name']
    @text.text = post['text']
    @text.adjustsFontSizeToFitWidth = false
    @text.sizeToFit
  end

end
