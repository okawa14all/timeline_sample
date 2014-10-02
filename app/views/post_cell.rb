class PostCell < UITableViewCell

  def rmq_build
    q = rmq(self.contentView)
    @user_name_label = q.append(UILabel, :user_name_label).get
    @text = q.append(UILabel, :text).get

    if self.respondsToSelector('layoutMargins')
      self.layoutMargins = UIEdgeInsetsZero
    end
  end

  def update(post)
    @user_name_label.text = post['user']['name']

    frame = @text.frame
    frame.size = CGSizeMake(rmq.stylesheet.text_width, 0)
    @text.setFrame(frame)

    @text.text = post['text']
    @text.sizeToFit
  end

end
