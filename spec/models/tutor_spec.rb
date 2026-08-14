require 'rails_helper'

RSpec.describe Tutor, type: :model do
  describe "associations" do
    it { should belong_to(:course) }
  end

  describe "validations" do
    subject { build(:tutor, course: create(:course)) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
  end

  describe "factory" do
    it "creates valid tutor" do
      expect(build(:tutor)).to be_valid
    end
  end
end
