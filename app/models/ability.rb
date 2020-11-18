class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    alias_action :create, :read, :update, :destroy, :to => :crud
    alias_action :update, :destroy, :to => :modify

    can :read, Dog
    # only allow a user to do dangerous actions if the doggie is theirs
    can :modify, Dog, user_id: user.id
  end
end
