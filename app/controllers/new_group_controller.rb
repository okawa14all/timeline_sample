class NewGroupController < UIViewController
  attr_accessor :delegate

  def viewDidLoad
    super
    self.edgesForExtendedLayout = UIRectEdgeNone
    rmq.stylesheet = NewGroupControllerStylesheet
    init_nav
    rmq(self.view).apply_style :root_view

    self.delegate = rmq.app.delegate.members_controller

    @name = rmq.append(UITextField, :name).get
    left_padding = rmq.append(UIView, :text_field_padding).get
    @name.leftView = left_padding

    rmq.append(UIButton, :submit_button).on(:touch) do |sender|
      create_new_group
    end

  end

  def init_nav
    self.title = 'グループ作成'

    self.navigationItem.tap do |nav|
      nav.leftBarButtonItem = UIBarButtonItem.alloc.initWithTitle(
        'キャンセル',
        style: UIBarButtonItemStylePlain,
        target: self,
        action: :dismissView
      )
    end
  end

  def dismissView
    delegate.dismissNewGroupController
  end

  def change_group_to(group)
    rmq.app.delegate.timeline_controller.current_group = group
    rmq.app.delegate.members_controller.current_group = group
  end

  def create_new_group
    puts "create new group name = #{@name.text}"
    new_group = PFObject.objectWithClassName('Group')
    new_group['name'] = @name.text
    new_group.saveInBackgroundWithBlock -> (succeeded, error) {
      if error
        puts error
      else
        puts new_group.objectId
        join_group(new_group)
      end
    }
  end

  def join_group(group)
    puts "join group name=#{group['name']}, id=#{group.objectId}"
    group_user = PFObject.objectWithClassName('GroupUser')
    group_user['group'] = group
    group_user['user'] = PFUser.currentUser
    group_user.saveInBackgroundWithBlock -> (succeeded, error) {
      if error
        puts error
        # TODO delete group?
        delegate.newGroupDidCreated(group, error)
      else
        puts "success to join group (#{group_user.objectId})"
        change_group_to(group)
        delegate.newGroupDidCreated(group, nil)
      end
    }
    delegate.newGroupWillCreate(group)
  end

end
