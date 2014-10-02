class GroupsControllerStylesheet < ApplicationStylesheet
  # Add your view stylesheets here. You can then override styles if needed, example:
  include GroupCellStylesheet

  def setup
    # Add stylesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb
  end

  def root_view(st)
    st.background_color = color.white
  end

  def setting_button(st)
    st.frame = { fr: 5, t: 5, w: 25, h: 25 }
    st.image = FAKIonIcons.ios7GearIconWithSize(50).imageWithSize(CGSizeMake(50, 50))
  end

  def groups_table(st)
    st.frame = { l: 0, t: 50, w: app_width, h: app_height }
  end
end
