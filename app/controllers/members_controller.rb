class MembersController < UIViewController
  include BW::KVO
  attr_accessor :current_group

  TAB_INDEX = 1
  MEMBER_CELL_ID = 'MemberCell'

  def initWithNibName(name, bundle: bundle)
    super
    icon = FAKIonIcons.ios7PeopleOutlineIconWithSize 30
    iconSelected = FAKIonIcons.ios7PeopleIconWithSize 30
    self.tabBarItem.image = icon.imageWithSize(CGSizeMake(30, 30))
    self.tabBarItem.selectedImage = iconSelected.imageWithSize(CGSizeMake(30, 30))
    self.tabBarItem.title = 'Members'
    self
  end

  def viewDidLoad
    super
    self.edgesForExtendedLayout = UIRectEdgeNone
    rmq.stylesheet = MembersControllerStylesheet
    init_nav
    rmq(self.view).apply_style :root_view

    @tableView = rmq.append(UITableView, :members_table).get.tap do |tv|
      tv.delegate = self
      tv.dataSource = self
      tv.setSeparatorInset(UIEdgeInsetsZero)
      if tv.respondsToSelector('layoutMargins')
        tv.layoutMargins = UIEdgeInsetsZero
      end
    end

    @indicator_view = MONActivityIndicatorView.new
    point = self.view.center
    @indicator_view.center = CGPointMake(point.x, point.y - 100)
    self.view.addSubview(@indicator_view)

    @should_reload = true

    observe(:current_group) do |old_value, new_value|
      puts '********** [MembersController] detect current_group changed'
      unless old_value == new_value
        @should_reload = true
        p self.tabBarController.selectedViewController
      end
    end

    show_loading_indicator
  end

  def viewDidAppear(animated)
    load_members if @should_reload
  end

  def init_nav
    self.title = 'メンバー'

    self.navigationItem.tap do |nav|
      nav.rightBarButtonItem = UIBarButtonItem.alloc.initWithTitle(
        '追加',
        style: UIBarButtonItemStylePlain,
        target: self,
        action: :open_add_member_controller
      )
      nav.leftBarButtonItem = UIBarButtonItem.alloc.initWithTitle(
        'グループ',
        style: UIBarButtonItemStylePlain,
        target: self,
        action: :open_groups_controller
      )
    end
  end

  def open_login_controller
    login_controller = UINavigationController.alloc.initWithRootViewController(LoginController.new)
    self.presentViewController(login_controller, animated:false, completion:nil)
  end

  def open_groups_controller
    controller = GroupsController.new
    controller.current_group = @current_group
    controller.delegate = self
    nav_controller = UINavigationController.alloc.initWithRootViewController(controller)
    self.presentViewController(nav_controller, animated:true, completion:nil)
  end

  def open_add_member_controller
    controller = AddMemberController.new
    controller.current_group = @current_group
    controller.current_users = @users
    controller.delegate = self
    self.navigationController.pushViewController(controller, animated:true)
  end

  def load_members
    puts "*** load members of #{@current_group['name']}"
    Group.find_members_of(@current_group) do |users, error|
      if error
        #show alert
      else
        @users = users
        @tableView.reloadData
        @should_reload = false
        hide_loading_indicator
      end
    end
  end

  def show_loading_indicator
    rmq(@tableView).hide
    @indicator_view.startAnimating
  end

  def hide_loading_indicator
    @indicator_view.stopAnimating
    rmq(@tableView).show
  end

  #---------- UITableView delegate ----------
  def tableView(table_view, numberOfRowsInSection: section)
    @users.present? ? @users.length : 0
  end

  def tableView(table_view, heightForRowAtIndexPath: index_path)
    rmq.stylesheet.member_cell_height
  end

  def tableView(table_view, cellForRowAtIndexPath: index_path)
    user = @users[index_path.row]
    cell = table_view.dequeueReusableCellWithIdentifier(MEMBER_CELL_ID) || begin
      rmq.create(
        MemberCell, :member_cell,
        reuse_identifier: MEMBER_CELL_ID,
        cell_style: UITableViewCellStyleDefault
      ).get
    end
    cell.update(user)
    cell
  end

  def tableView(table_view, didSelectRowAtIndexPath: index_path)
    user = @users[index_path.row]
    puts user['name']
  end

  #---------- GroupsController delegates ----------
  def dismissGroupsController
    self.dismissViewControllerAnimated(true, completion:nil)
  end

  def groupDidChanged(group)
    show_loading_indicator
    dismissGroupsController
  end

  def after_loged_out
    dismissGroupsController
    open_login_controller
  end

  #---------- NewGroupController delegates ----------
  def dismissNewGroupController
    self.dismissViewControllerAnimated(true, completion:nil)
  end

  def newGroupWillCreate(group)
    puts '*** newGroupWillCreate'
  end

  def newGroupDidCreated(group, error)
    puts '*** newGroupDidCreated'
    self.tabBarController.selectedIndex = TAB_INDEX
    show_loading_indicator
    dismissNewGroupController
  end

  #---------- AddMemberController delegates ----------
  def after_added_users
    puts '*** after_added_users'
    show_loading_indicator
    @should_reload = true
    self.navigationController.popViewControllerAnimated(true)
  end
end
