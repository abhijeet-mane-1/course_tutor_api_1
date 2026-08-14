class Tutor < ApplicationRecord
  belongs_to :course

  validates :name, :email, presence: true
  validates :email, uniqueness: true
end
