require 'rails_helper'

RSpec.describe Course, type: :model do
  describe "associations" do
    it { should have_many(:tutors)}
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
  end

  describe "destroy behaviour" do
    it "destroys accosiated tutor" do
      course = create(:course)
      create(:tutor, course: course)

      expect {
        course.destroy
      }.to change(Tutor, :count).by(-1)
    end
  end
end
