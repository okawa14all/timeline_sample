class NewGroupControllerStylesheet < ApplicationStylesheet
  # Add your view stylesheets here. You can then override styles if needed, example:
  # include FooStylesheet

  def setup
    # Add stylesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb
  end

  def root_view(st)
    st.background_color = color.white
  end

  def name(st)
    st.frame = {l: 10, t: 100, w: app_width - 20, h: 50 }
    st.background_color = color.white
    st.view.font = font.small
    st.placeholder = 'グループ名'
    st.border_width = 1.0
    st.border_color = color.silver
    st.border_radius = 2
    st.masks_to_bounds = true
    st.view.leftViewMode = UITextFieldViewModeAlways
  end

  def submit_button(st)
    st.frame = {l: 10, t: 160, w: app_width - 20, h: 50}
    st.text = '作成'
    st.background_color = color.brand_color
    st.font = font.medium
    st.color = color.white
  end
end
