class State
  attr_accessor :group

  def self.current
    Dispatch.once { @@instance ||= new }
    @@instance
  end
end
