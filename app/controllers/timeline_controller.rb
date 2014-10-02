class TimelineController < UIViewController
  include BW::KVO
  attr_accessor :current_group

  TAB_INDEX = 0
  POST_CELL_ID = 'PostCell'

  def initWithNibName(name, bundle: bundle)
    super
    icon = FAKIonIcons.ios7ClockOutlineIconWithSize 30
    iconSelected = FAKIonIcons.ios7ClockIconWithSize 30
    self.tabBarItem.image = icon.imageWithSize(CGSizeMake(30, 30))
    self.tabBarItem.selectedImage = iconSelected.imageWithSize(CGSizeMake(30, 30))
    self.tabBarItem.title = 'Timeline'
    self
  end

  def viewDidLoad
    super
    self.edgesForExtendedLayout = UIRectEdgeNone
    rmq.stylesheet = TimelineControllerStylesheet
    init_nav
    rmq(self.view).apply_style :root_view

    @should_reload = true
    @post_cell_heights = {} # cache of cell height for each post

    @timeline_table_view = rmq.append(UITableView, :timeline_table_view).get.tap do |tv|
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

    observe(:current_group) do |old_value, new_value|
      puts '********** [TimelineController] detect current_group changed'
      unless old_value == new_value
        @should_reload = true
        @timeline_header.init_with_group(@current_group)
      end
    end

    show_loading_indicator
  end

  def viewWillAppear(animated)
    unless PFUser.currentUser
      open_login_controller
    end
  end

  def viewDidAppear(animated)
    load_timeline if @should_reload
  end

  def init_nav
    self.title = 'Chambre' # TODO show logo image

    self.navigationItem.tap do |nav|
      nav.rightBarButtonItem = UIBarButtonItem.alloc.initWithTitle(
        '投稿',
        style: UIBarButtonItemStylePlain,
        target: self,
        action: :open_post_controller
      )
      nav.leftBarButtonItem = UIBarButtonItem.alloc.initWithTitle(
        'グループ',
        style: UIBarButtonItemStylePlain,
        target: self,
        action: :open_groups_controller
      )
    end
  end

  def open_post_controller
    controller = PostController.new
    controller.delegate = self
    controller.current_group = @current_group
    nav_controller = UINavigationController.alloc.initWithRootViewController(controller)
    self.presentViewController(nav_controller, animated:true, completion:nil)
  end

  def open_groups_controller
    controller = GroupsController.new
    controller.current_group = @current_group
    controller.delegate = self
    nav_controller = UINavigationController.alloc.initWithRootViewController(controller)
    self.presentViewController(nav_controller, animated:true, completion:nil)
  end

  def open_post_detail_controller(post)
    puts 'open_post_detail_controller'
  end

  def open_login_controller
    login_controller = UINavigationController.alloc.initWithRootViewController(LoginController.new)
    self.presentViewController(login_controller, animated:false, completion:nil)
  end

  def load_timeline
    puts "*** load_timeline of #{@current_group['name']}"
    Post.find_by_group(@current_group) do |posts, error|
      if error
        # show alert
      else
        @posts = posts
        @timeline_table_view.reloadData
        @should_reload = false
        hide_loading_indicator
      end
    end
  end

  def show_loading_indicator
    rmq(@timeline_table_view).hide
    @indicator_view.startAnimating
  end

  def hide_loading_indicator
    @indicator_view.stopAnimating
    rmq(@timeline_table_view).show
  end

  #---------- UITableView delegate ----------
  def tableView(table_view, numberOfRowsInSection: section)
    @posts.present? ? @posts.length : 0
  end

  # called before tableView:cellForRowAtIndexPath
  def tableView(table_view, heightForRowAtIndexPath: index_path)
    post = @posts[index_path.row]
    @post_cell_heights[post.objectId] ||= cell_height_of(post)
  end

  def tableView(table_view, cellForRowAtIndexPath: index_path)
    post = @posts[index_path.row]
    cell = table_view.dequeueReusableCellWithIdentifier(POST_CELL_ID) || begin
      rmq.create(
        PostCell, :post_cell,
        reuse_identifier: POST_CELL_ID,
        cell_style: UITableViewCellStyleSubtitle
      ).get
    end

    cell.update(post)
    cell
  end

  def tableView(table_view, didSelectRowAtIndexPath: index_path)
    post = @posts[index_path.row]
    open_post_detail_controller(post)
  end

  def tableView(table_view, heightForHeaderInSection: section)
    rmq.stylesheet.timeline_header_height
  end

  def tableView(table_view, viewForHeaderInSection: section)
    @timeline_header ||= rmq.create(TimelineHeader).get.tap do |header|
      header.init_with_group(@current_group)
    end
  end

  def tableView(table_view, heightForFooterInSection: section)
    rmq.stylesheet.timeline_footer_height
  end

  def tableView(table_view, viewForFooterInSection: section)
    @timeline_footer ||= rmq.create(TimelineFooter).get
  end

  # Enable to scroll UITableView's section header
  # (originally, section header behave like "position:fixed" header.)
  def scrollViewDidScroll(scroll_view)
    offsetY = scroll_view.contentOffset.y
    header_height = rmq.stylesheet.timeline_header_height
    if offsetY <= header_height && offsetY >= 0
      scroll_view.contentInset = UIEdgeInsetsMake(-offsetY, 0, 0, 0);
    elsif offsetY >= header_height
      scroll_view.contentInset = UIEdgeInsetsMake(-header_height, 0, 0, 0);
    end
  end

  # calcurate cell height. used by tableView:heightForRowAtIndexPath
  def cell_height_of(post)
    puts "------------ cell_height_of #{post.objectId}"
    text = post['text']

    modified_size = text.boundingRectWithSize(
      CGSizeMake(rmq.stylesheet.text_width, Float::MAX),
      options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine,
      attributes: {NSFontAttributeName => rmq.stylesheet.text_font},
      context: nil
    ).size

    h = modified_size.height + rmq.stylesheet.user_area_height_of_cell + rmq.stylesheet.padding_bottom

    puts "textview height: #{modified_size.height}"
    puts "user_area_height: #{rmq.stylesheet.user_area_height_of_cell}"
    puts "padding_bottom: #{rmq.stylesheet.padding_bottom}"
    puts "total: #{h}"
    h.ceil
  end

  #---------- PostController delegates ----------
  def dismissPostController
    self.dismissViewControllerAnimated(true, completion:nil)
  end

  def postWillSave(post)
    dismissPostController
    # show indicator?
  end

  def postDidSave(post, error)
    if error
      # show alert
    else
      @posts.unshift(post)
      path = NSIndexPath.indexPathForRow(0, inSection: 0)
      @timeline_table_view.insertRowsAtIndexPaths(
        [path],
        withRowAnimation: UITableViewRowAnimationFade
      )
    end
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
end
