class TimelineControllerStylesheet < ApplicationStylesheet
  # Add your view stylesheets here. You can then override styles if needed, example:
  include PostCellStylesheet
  include TimelineHeaderStylesheet
  include TimelineFooterStylesheet

  def setup
    # Add stylesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb
  end

  def root_view(st)
    st.background_color = color.white
  end

  def timeline_table_view(st)
    st.frame = { t: 0, l: 0, w: app_width, h: app_height - 44 }
    st.background_color = color.clear
  end
end
