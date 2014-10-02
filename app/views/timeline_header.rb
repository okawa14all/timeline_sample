class TimelineHeader < UIView

  def rmq_build
    puts '### create TimelineHeader'
    q = rmq(self)
    q.apply_style :timeline_header

    @group_name_label = q.append(UILabel, :group_name_label).get
  end

  def init_with_group(group)
    puts '###### init_with_group TimelineHeader'
    @group_name_label.text = group['name']
  end

end
