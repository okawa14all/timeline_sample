class LoginController < UIViewController

  def viewDidLoad
    super

    self.edgesForExtendedLayout = UIRectEdgeNone

    rmq.stylesheet = LoginControllerStylesheet
    init_nav
    rmq(self.view).apply_style :root_view

    @email = rmq.append(UITextField, :email).get
    email_left_padding = rmq.append(UIView, :text_field_padding).get
    @email.leftView = email_left_padding

    @password = rmq.append(UITextField, :password).get
    password_left_padding = rmq.append(UIView, :text_field_padding).get
    @password.leftView = password_left_padding

    rmq.append(UIButton, :submit_button).on(:touch) do |sender|
      login
    end

    rmq.append(UIView, :divider)

    rmq.append(UIButton, :login_with_facebook_button).on(:touch) do |sender|
      login_with_facebook
    end

    rmq.append(UIButton, :login_with_twitter_button).on(:touch) do |sender|
      login_with_twitter
    end

  end

  def init_nav
    self.title = 'Login'
  end

  def login
    unless rmq.validation.valid?(@email.text, :email)
      SimpleSI.alert(
        message: 'invalid email',
        transition: 'drop_down')
      return
    end

    unless rmq.validation.valid?(@password.text, :presence)
      SimpleSI.alert(
        message: 'invalid password',
        transition: 'drop_down')
      return
    end

    # SVProgressHUD.show

    SVProgressHUD.showWithMaskType(SVProgressHUDMaskTypeGradient)

    PFUser.logInWithUsernameInBackground(@email.text, password: @password.text,
      block: lambda do |user, error|
        SVProgressHUD.dismiss
        if user
          puts "login success! #{user['name']}"
          # TODO
          # - get own group(with members) from parse.com (PFRole)
          # - save own group and members to userdefault
          dismissView
        else
          puts 'login failed!'
          errorString = error.userInfo["error"]
          SimpleSI.alert(
            message: errorString,
            transition: 'drop_down')
        end
      end
    )
  end

  def login_with_facebook
    SVProgressHUD.showWithMaskType(SVProgressHUDMaskTypeGradient)

    PFFacebookUtils.logInWithPermissions(nil,
      block: lambda do |user, error|
        if !user
          SVProgressHUD.dismiss
          if !error
            puts 'user cancelled the Facebook login'
          else
            puts 'facebook login failed!'
            errorString = error.userInfo["error"]
            SimpleSI.alert(
              message: errorString,
              transition: 'drop_down')
          end
        elsif user.isNew
          puts 'User signed up and logged in through Facebook!'
          handle_fb_login_user
        else
          puts 'User logged in through Facebook!'
          handle_fb_login_user
        end
      end
    )
  end

  def handle_fb_login_user
    request = FBRequest.requestForMe
    request.startWithCompletionHandler(
      lambda do |connection, result, error|
        SVProgressHUD.dismiss
        if !error
          name = result['name']
          puts "Facebook user name is #{name}"
          user = PFUser.currentUser
          user['name'] = name
          user.save # maybe saveInBackgroundWithBlock is better
          dismissView
        else
          puts error.userInfo["error"]
        end
      end
    )
  end

  def login_with_twitter
    SVProgressHUD.showWithMaskType(SVProgressHUDMaskTypeGradient)

    PFTwitterUtils.logInWithBlock(
      lambda do |user, error|
        if !user
          SVProgressHUD.dismiss
          if !error
            puts 'user cancelled the Twitter login'
          else
            puts 'Twitter login failed!'
            errorString = error.userInfo["error"]
            SimpleSI.alert(
              message: errorString,
              transition: 'drop_down')
          end
        elsif user.isNew
          puts 'User signed up and logged in through Twitter!'
          handle_tw_login_user
        else
          puts 'User logged in through Twitter!'
          handle_tw_login_user
        end
      end
    )
  end

  def handle_tw_login_user
    # TODO: use better http client like AFHTTPSessionManager (> iOS7)
    #       or use twitter sdk
    url = NSURL.URLWithString("https://api.twitter.com/1.1/account/verify_credentials.json")
    request = NSMutableURLRequest.requestWithURL(url)
    PFTwitterUtils.twitter.signRequest(request)
    response = nil
    error = nil
    data = NSURLConnection.sendSynchronousRequest(request,
      returningResponse: response,
      error: error
    )
    SVProgressHUD.dismiss
    if data
      json = BubbleWrap::JSON.parse(data)
      if json['errors']
        puts json['errors']['message']
      else
        name = json['screen_name']
        puts "Twitter screen_name is #{name}"
        user = PFUser.currentUser
        user['name'] = name
        user.save # maybe saveInBackgroundWithBlock is better
        dismissView
      end
    else
      puts 'Cloud not recieve data from twitter'
    end
  end

  def dismissView
    self.dismissViewControllerAnimated(true, completion:nil)
  end

end
