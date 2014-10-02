class PostController < UIViewController
  attr_accessor :delegate, :current_group

  def viewDidLoad
    super
    self.edgesForExtendedLayout = UIRectEdgeNone
    rmq.stylesheet = PostControllerStylesheet
    init_nav
    rmq(self.view).apply_style :root_view

    puts "create post to #{@current_group['name']}"

    @textView = rmq.append(UITextView, :text_area).get

  end

  def init_nav
    self.title = '投稿'

    self.navigationItem.tap do |nav|
      nav.rightBarButtonItem = UIBarButtonItem.alloc.initWithTitle(
        '保存',
        style: UIBarButtonItemStylePlain,
        target: self,
        action: :create_new_post
      )
      nav.leftBarButtonItem = UIBarButtonItem.alloc.initWithTitle(
        'キャンセル',
        style: UIBarButtonItemStylePlain,
        target: self,
        action: :dismissView
      )
    end
  end

  def dismissView
    delegate.dismissPostController
  end

  def create_new_post
    unless rmq.validation.valid?(@textView.text, :presence)
      puts 'text is blank'
      return
    end

    new_post = PFObject.objectWithClassName('Post')
    new_post['text'] = @textView.text
    new_post['group'] = @current_group
    new_post['user'] = PFUser.currentUser
    # set PFACL here
    new_post.saveInBackgroundWithBlock -> (succeeded, error) {
      if error
        puts error
        delegate.postDidSave(new_post, error)
      else
        puts "#### new post(#{new_post.objectId}) to #{@current_group['name']} was saved"
        delegate.postDidSave(new_post, nil)
      end
    }
    delegate.postWillSave(new_post)
  end

end
