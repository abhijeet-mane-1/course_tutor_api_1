class TutorSerializer < ActiveModel::Serializer
  type :tutors

  attributes :name, :email
end
