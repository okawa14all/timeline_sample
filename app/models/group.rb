class Group

  def self.find_by_user(user, &callback)
    groups = nil
    query = PFQuery.queryWithClassName('GroupUser')
    query.whereKey('user', equalTo: user)
    query.includeKey('group')
    query.findObjectsInBackgroundWithBlock -> (user_groups, error) {
      if error
        puts 'failed to fetch groups'
        puts error
      else
        puts 'success to fetch groups'
        groups = user_groups.map{|user_group| user_group['group']}
      end
      callback.call(groups, error)
    }
  end

  def self.first_by_user(user)
    query = PFQuery.queryWithClassName('GroupUser')
    query.whereKey('user', equalTo: user)
    query.includeKey('group')
    user_group = query.getFirstObject
    user_group.present? ? user_group['group'] : nil
  end

  def self.find_members_of(group, &callback)
    query = PFQuery.queryWithClassName('GroupUser')
    query.whereKey('group', equalTo: group)
    query.includeKey('user')
    query.findObjectsInBackgroundWithBlock -> (group_users, error) {
      if error
        puts error
        callback.call(nil, error)
      else
        users = group_users.map{|group_user| group_user['user']}
        callback.call(users, nil)
      end
    }
  end
end
