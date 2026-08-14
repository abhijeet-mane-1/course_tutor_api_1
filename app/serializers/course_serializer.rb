class CourseSerializer < ActiveModel::Serializer
  type :courses

  attributes :name, :description

  has_many :tutors
end
