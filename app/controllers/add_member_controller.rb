class AddMemberController < UIViewController
  attr_accessor :delegate, :current_group, :current_users

  ADD_MEMBER_CELL_ID = "GroupCell"

  def viewDidLoad
    super
    self.edgesForExtendedLayout = UIRectEdgeNone
    rmq.stylesheet = AddMemberControllerStylesheet
    init_nav
    rmq(self.view).apply_style :root_view

    @tableView = rmq.append(UITableView, :add_member_table).get.tap do |tv|
      tv.delegate = self
      tv.dataSource = self
      tv.setSeparatorInset(UIEdgeInsetsZero)
      if tv.respondsToSelector('layoutMargins')
        tv.layoutMargins = UIEdgeInsetsZero
      end
    end

    query = PFUser.query
    current_users_ids = @current_users.map{|user| user.objectId}
    puts current_users_ids
    query.whereKey('objectId', notContainedIn: current_users_ids)
    query.findObjectsInBackgroundWithBlock -> (users, error) {
      if error
        puts error
      else
        @users = users
        @tableView.reloadData
      end
    }
  end

  def init_nav
    self.title = 'メンバー追加'
  end

  def add_user(user)
    puts "add_user name = #{user['name']}"
    group_user = PFObject.objectWithClassName('GroupUser')
    group_user['group'] = @current_group
    group_user['user'] = user
    group_user.saveInBackgroundWithBlock -> (succeeded, error) {
      if error
        puts error
      else
        delegate.after_added_users
      end
    }
  end

  #---------- UITableView delegate ----------
  def tableView(table_view, numberOfRowsInSection: section)
    @users.present? ? @users.length : 0
  end

  def tableView(table_view, heightForRowAtIndexPath: index_path)
    rmq.stylesheet.add_member_cell_height
  end

  def tableView(table_view, cellForRowAtIndexPath: index_path)
    user = @users[index_path.row]
    cell = table_view.dequeueReusableCellWithIdentifier(ADD_MEMBER_CELL_ID) || begin
      rmq.create(
        AddMemberCell, :add_member_cell,
        reuse_identifier: ADD_MEMBER_CELL_ID,
        cell_style: UITableViewCellStyleDefault
      ).get
    end

    cell.update(user)

    button = rmq.create(UIButton, :add_button).on(:touch) do |sender|
      add_user(user)
    end.get
    cell.accessoryView = button

    cell
  end

  def tableView(table_view, didSelectRowAtIndexPath: index_path)
  end
end
