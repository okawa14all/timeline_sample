module TimelineHeaderStylesheet

  def timeline_header_height
    100
  end

  def timeline_header(st)
    st.frame = {l: 0, t: 0, w: app_width, h: timeline_header_height}
    st.background_color = color.silver
  end

  def group_name_label(st)
    st.frame = {l: 0, t: 0, w: app_width, h: timeline_header_height, centered: :horizontal}
    st.background_color = color.clear
    st.text_alignment = :center
    st.font = font.medium
  end

end
