class PostDetailController < SLKTextViewController
  attr_accessor :post

  def init
    super.initWithTableViewStyle(UITableViewStylePlain)
  end

  def viewDidLoad
    super
    self.edgesForExtendedLayout = UIRectEdgeNone
    rmq.stylesheet = PostDetailControllerStylesheet
    init_nav
    rmq(self.view).apply_style :root_view
  end

  def init_nav
    self.title = '投稿詳細'
    self.navigationItem.tap do |nav|
      nav.leftBarButtonItem = UIBarButtonItem.alloc.initWithTitle(
        '閉じる',
        style: UIBarButtonItemStylePlain,
        target: self,
        action: :dismissView
      )
    end
  end

  def dismissView
    self.dismissViewControllerAnimated(true, completion:nil)
  end

end
