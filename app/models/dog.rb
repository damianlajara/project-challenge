class Dog < ApplicationRecord
  acts_as_votable
  has_many_attached :images
  belongs_to :owner, class_name: "User", foreign_key: :user_id, optional: true
end
