class MainController < UIViewController

  def viewDidLoad
    super

    rmq.stylesheet = MainStylesheet
    init_nav
    rmq(self.view).apply_style :root_view

    rmq.append(UILabel, :hello_world).get
  end

  def viewDidAppear(animated)
    if PFUser.currentUser
      fetchTimeline
    else
      open_login_controller
    end
  end

  def init_nav
    self.title = 'Timeline'
    self.navigationItem.tap do |nav|
      nav.rightBarButtonItem = UIBarButtonItem.alloc.initWithTitle(
        '投稿',
        style: UIBarButtonItemStylePlain,
        target: self,
        action: :open_post_controller
      )
      nav.leftBarButtonItem = UIBarButtonItem.alloc.initWithTitle(
        'ログアウト',
        style: UIBarButtonItemStylePlain,
        target: self,
        action: :logout
      )
    end
  end

  def nav_left_button
    puts 'Left button'
  end

  def nav_right_button
    puts 'Right button'
  end

  def fetchTimeline
    puts 'fetchTimeline'
    # TODO
    # get own group from userdefault
    # get timeline from parse.com
    # show timeline on tableview
  end

  # TODO
  # - pull refresh

  def logout
    puts 'logout'
    PFUser.logOut
    # TODO
    # delete userdefaults
    open_login_controller
  end

  def open_login_controller
    login_controller = UINavigationController.alloc.initWithRootViewController(LoginController.new)
    self.presentViewController(login_controller, animated:false, completion:nil)
  end

  def open_post_controller
    puts 'open_post_controller'
  end

end
