class ApplicationStylesheet < RubyMotionQuery::Stylesheet

  def application_setup
    font_family = 'HelveticaNeue-Light'
    font.add_named :large,    font_family, 36
    font.add_named :medium,   font_family, 24
    font.add_named :small,    font_family, 18

    color.add_named :brand_color, '#48CCDF'
    color.add_named :ivory, '#FFFFF0'
    color.add_named :silver, '#ccc'
    color.add_named :default_font_color, '#5b686a'
    
    color.add_named :fb_button_bg_color, '#3b5998'
    color.add_named :tw_button_bg_color, '#55acee'

    SVProgressHUD.appearance.hudBackgroundColor = color.from_rgba(255, 255, 255, 0.5)
  end

  def standard_button(st)
    st.frame = {w: 40, h: 18}
    st.background_color = color.tint
    st.color = color.white
  end

  def standard_label(st)
    st.frame = {w: 40, h: 18}
    st.background_color = color.clear
    st.color = color.black
  end

  def text_field_padding(st)
    st.frame = {l: 0, t: 0, w: 10, h: 50 }
    st.view.opaque = false
    st.background_color = color.clear
  end

end
