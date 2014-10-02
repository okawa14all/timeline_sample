class TimelineFooter < UIView

  def rmq_build
    puts '### create TimelineFooter'
    q = rmq(self)
    q.apply_style :timeline_footer

    q.append(UILabel, :footer_label)
  end

end
