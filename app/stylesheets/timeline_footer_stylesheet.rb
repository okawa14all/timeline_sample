module TimelineFooterStylesheet
  def timeline_footer_height
    50
  end

  def timeline_footer(st)
    st.frame = { l: 0, t: 0, w: app_width, h: timeline_footer_height }
    st.background_color = color.silver
  end

  def footer_label(st)
    st.frame = { l: 0, t: 0, w: app_width, h: timeline_footer_height, centered: :horizontal }
    st.background_color = color.clear
    st.text_alignment = :center
    st.font = font.small
    st.text = 'footer'
  end

end
