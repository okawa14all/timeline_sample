module PostCellStylesheet
  def user_area_height_of_cell
    40
  end

  def text_font
    font.small
  end

  def text_color
    color.black
  end

  def text_width
    app_width - 20
  end

  def padding_bottom
    20
  end

  def post_cell(st)
    st.background_color = color.clear
    st.view.selectionStyle = UITableViewCellSelectionStyleNone
  end

  def user_name_label(st)
    st.frame = { l: 5, t: 0, w: app_width - 10, h: user_area_height_of_cell }
    st.color = color.gray
    st.font = font.small
  end

  def text(st)
    st.frame = { l: 10, t: user_area_height_of_cell, w: text_width, h: 0 }
    st.font = text_font
    st.number_of_lines = 0
    st.background_color = color.ivory
    st.line_break_mode = NSLineBreakByWordWrapping
    st.adjusts_font_size = false
  end

end
