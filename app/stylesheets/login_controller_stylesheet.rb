class LoginControllerStylesheet < ApplicationStylesheet
  # Add your view stylesheets here. You can then override styles if needed, example:
  # include FooStylesheet

  def setup
    # Add stylesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb
  end

  def root_view(st)
    st.background_color = color.white
  end

  def email(st)
    st.frame = {l: 10, t: 50, w: app_width - 20, h: 50 }
    st.background_color = color.white
    st.view.font = font.small
    st.placeholder = 'Email'
    st.border_width = 1.0
    st.border_color = color.silver
    st.border_radius = 2
    st.masks_to_bounds = true
    st.view.leftViewMode = UITextFieldViewModeAlways
  end

  def password(st)
    st.frame = {l: 10, t: 110, w: app_width - 20, h: 50}
    st.background_color = color.white
    st.view.font = font.small
    st.placeholder = 'Password'
    st.view.secureTextEntry = true
    st.border_width = 1.0
    st.border_color = color.silver
    st.border_radius = 2
    st.masks_to_bounds = true
    st.view.leftViewMode = UITextFieldViewModeAlways
  end

  def submit_button(st)
    st.frame = {l: 10, t: 170, w: app_width - 20, h: 50}
    st.text = 'Log In'
    st.background_color = color.brand_color
    st.font = font.small
    st.color = color.white
  end

  def divider(st)
    st.frame = {l: 20, t: 240, w: app_width - 40, h: 1}
    st.background_color = color.silver
  end

  def login_with_facebook_button(st)
    st.frame = {l: 10, t: 260, w: app_width - 20, h: 50}
    st.text = 'Log In with Facebook'
    st.background_color = color.fb_button_bg_color
    st.font = font.small
    st.color = color.white
  end

  def login_with_twitter_button(st)
    st.frame = {l: 10, t: 320, w: app_width - 20, h: 50}
    st.text = 'Log In with Twitter'
    st.background_color = color.tw_button_bg_color
    st.font = font.small
    st.color = color.white
  end
end
