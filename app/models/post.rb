class Post
  def self.find_by_group(group, &callback)
    query = PFQuery.queryWithClassName('Post')
    query.whereKey('group', equalTo: group)
    query.orderByDescending('createdAt')
    query.includeKey('user')
    query.findObjectsInBackgroundWithBlock -> (posts, error) {
      if error
        puts 'failed to fetch posts'
        puts error
        callback.call(nil, error)
      else
        puts 'success to fetch posts'
        callback.call(posts, nil)
      end
    }
  end
end
