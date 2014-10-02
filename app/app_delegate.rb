class AppDelegate
  attr_reader :window, :timeline_controller, :members_controller

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    application.setStatusBarStyle(UIStatusBarStyleLightContent)

    self.configure_parse_service(launchOptions)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    # tab 1
    @timeline_controller = TimelineController.alloc.initWithNibName(nil, bundle: nil)
    tab1_controller = UINavigationController.alloc.initWithRootViewController(@timeline_controller)

    # tab 2
    @members_controller = MembersController.alloc.initWithNibName(nil, bundle: nil)
    tab2_controller = UINavigationController.alloc.initWithRootViewController(@members_controller)

    @tab_controller = UITabBarController.new
    @tab_controller.viewControllers = [tab1_controller, tab2_controller]
    @window.rootViewController = @tab_controller

    init_navbar
    init_tabbar
    init_group

    @window.makeKeyAndVisible
    true
  end

  def application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    FBAppCall.handleOpenURL(url, sourceApplication:sourceApplication, withSession:PFFacebookUtils.session)
  end

  def applicationDidBecomeActive(application)
    FBAppCall.handleDidBecomeActiveWithSession(PFFacebookUtils.session)
  end

  def configure_parse_service(launchOptions)
    Parse.setApplicationId(
      "H3d0oKIfdQ6sUDp3homJk5otvFkHZw3v4fZknyiA",
      clientKey:"5fBRiVsT8SPm29PXtiLQRpBgPwDMP3a3ZPuEzo36")

    PFFacebookUtils.initializeFacebook

    PFTwitterUtils.initializeWithConsumerKey(
      "mlKm8eYAEICGShd8kv3etQutI",
      consumerSecret: "mHsvKkF9mCGt92A3x9Ogn7qR7oLAOWFKL8ewDq5voYnjCu2VuM")
  end

  def init_navbar
    # common appearance
    UINavigationBar.appearance.barTintColor = rmq.color.from_hex('#48CCDF')
    UINavigationBar.appearance.tintColor = rmq.color.white
    UINavigationBar.appearance.titleTextAttributes = {
      NSFontAttributeName => UIFont.fontWithName("HelveticaNeue-Light", size:20),
      NSForegroundColorAttributeName => rmq.color.white
    }
  end

  def init_tabbar
    # common appearance
    selectedColor = rmq.color.from_hex('#505050')
    UITabBarItem.appearance.setTitleTextAttributes({
        NSFontAttributeName => UIFont.fontWithName("HelveticaNeue-Light", size:10),
      NSForegroundColorAttributeName => selectedColor },
      forState: UIControlStateSelected)
    UITabBar.appearance.setSelectedImageTintColor(selectedColor)
  end

  def init_group
    if PFUser.currentUser
      group = Group.first_by_user(PFUser.currentUser)
      puts "##### set initial group to #{group['name']}"
      if group.present?
        @timeline_controller.current_group = group
        @members_controller.current_group = group
      else
        # TODO error handling(show alert?)
      end
    end
  end

end
