require "rails_helper"

RSpec.describe CourseSerializer do
  let(:course) { create(:course) }

  before do
    create(
      :tutor,
      course: course,
      name: "John Doe",
      email: "john@example.com"
    )
  end

  it "serializes a course using JSON:API" do
    serialized = ActiveModelSerializers::SerializableResource.new(
      course,
      serializer: CourseSerializer,
      adapter: :json_api
    ).as_json

    expect(serialized[:data][:type]).to eq("courses")
    expect(serialized[:data][:id]).to eq(course.id.to_s)

    expect(serialized[:data][:attributes]).to include(
      :name,
      :description
    )

    expect(serialized[:data][:relationships]).to have_key(:tutors)
  end
end
