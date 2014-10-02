class GroupsController < UIViewController
  attr_accessor :delegate, :current_group

  GROUP_CELL_ID = "GroupCell"

  def viewDidLoad
    super
    self.edgesForExtendedLayout = UIRectEdgeNone
    rmq.stylesheet = GroupsControllerStylesheet
    init_nav
    rmq(self.view).apply_style :root_view

    @setting_button = rmq.append(UIButton, :setting_button).on(:touch) do |sender|
      open_action_sheet
    end

    @tableView = rmq.append(UITableView, :groups_table).get.tap do |tv|
      tv.delegate = self
      tv.dataSource = self
      tv.setSeparatorInset(UIEdgeInsetsZero)
      if tv.respondsToSelector('layoutMargins')
        tv.layoutMargins = UIEdgeInsetsZero
      end
    end

    # Get own groups from Parse
    Group.find_by_user(PFUser.currentUser) do |groups, error|
      @groups = groups
      @tableView.reloadData
    end

  end

  def init_nav
    self.title = 'グループ'

    self.navigationItem.tap do |nav|
      nav.rightBarButtonItem = UIBarButtonItem.alloc.initWithTitle(
        '作成',
        style: UIBarButtonItemStylePlain,
        target: self,
        action: :open_new_group_controller
      )
      nav.leftBarButtonItem = UIBarButtonItem.alloc.initWithTitle(
        '閉じる',
        style: UIBarButtonItemStylePlain,
        target: self,
        action: :dismissView
      )
    end
  end

  def dismissView
    delegate.dismissGroupsController
  end

  def open_new_group_controller
    controller = NewGroupController.new
    self.navigationController.pushViewController(controller, animated: true)
  end

  def change_group_to(group)
    rmq.app.delegate.timeline_controller.current_group = group
    rmq.app.delegate.members_controller.current_group = group
    groupDidChanged(group)
  end

  def groupDidChanged(group)
    delegate.groupDidChanged(group)
  end

  def open_action_sheet
    alertController = UIAlertController.alertControllerWithTitle(
      'ログアウトしますか？',
      message: "#{PFUser.currentUser['name']}でログイン中",
      preferredStyle: UIAlertControllerStyleActionSheet
    )
    alertController.addAction(
      UIAlertAction.actionWithTitle(
        'はい',
        style: UIAlertActionStyleDefault,
        handler: ->(action) {
          logout
        }
      )
    )
    alertController.addAction(
      UIAlertAction.actionWithTitle(
        'いいえ',
        style: UIAlertActionStyleCancel,
        handler: ->(action) {
          puts 'canceled'
        }
      )
    )
    self.presentViewController(alertController, animated:true, completion:nil)
  end

  def logout
    puts 'logout'
    PFUser.logOut
    delegate.after_loged_out
  end

  #---------- UITableView delegate ----------
  def tableView(table_view, numberOfRowsInSection: section)
    @groups.present? ? @groups.length : 0
  end

  def tableView(table_view, heightForRowAtIndexPath: index_path)
    rmq.stylesheet.group_cell_height
  end

  def tableView(table_view, cellForRowAtIndexPath: index_path)
    group = @groups[index_path.row]
    cell = table_view.dequeueReusableCellWithIdentifier(GROUP_CELL_ID) || begin
      rmq.create(
        GroupCell, :group_cell,
        reuse_identifier: GROUP_CELL_ID,
        cell_style: UITableViewCellStyleDefault
      ).get
    end
    cell.update(group)
    cell
  end

  def tableView(table_view, didSelectRowAtIndexPath: index_path)
    group = @groups[index_path.row]
    if group.objectId != @current_group.objectId
      change_group_to(group)
    else
      dismissView
    end
  end

end
