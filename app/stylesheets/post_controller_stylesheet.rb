class PostControllerStylesheet < ApplicationStylesheet
  # Add your view stylesheets here. You can then override styles if needed, example:
  # include FooStylesheet

  def setup
    # Add stylesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb
  end

  def root_view(st)
    st.background_color = color.white
  end

  def text_area(st)
    st.frame = { l: 5, t: 10, w: app_width - 10, h: 200 }
    st.background_color = color.white
    st.view.font = font.small
    # st.text_color = color.gray
    st.border_width = 1.0
    st.border_color = color.silver
    st.border_radius = 2
  end
end
