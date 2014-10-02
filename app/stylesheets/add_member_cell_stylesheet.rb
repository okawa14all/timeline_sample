module AddMemberCellStylesheet
  def add_member_cell_height
    70
  end

  def add_member_cell(st)
    st.background_color = color.clear
    st.view.selectionStyle = UITableViewCellSelectionStyleNone
  end

  def cell_label(st)
    # st.color = color.white
  end

  def add_button(st)
    st.frame = { l: 0, t: 0, w: 60, h: 30 }
    st.text = '追加'
    st.font = font.small
    st.color = color.white
    st.background_color = color.brand_color
    st.border_radius = 6
  end

end
