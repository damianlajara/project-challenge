module DogsHelper
  def dog_can_be_liked_by_user?(dog)
    current_user && dog.try(:owner).try(:id) != current_user.id
  end
end
