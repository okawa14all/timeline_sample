describe 'Post' do

  before do
  end

  after do
  end

  it 'should create instance' do
    Post.create.is_a?(Post).should == true
  end
end
