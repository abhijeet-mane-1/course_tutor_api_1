require "rails_helper"

RSpec.describe CourseCreateService do
  describe "#call" do
    context "with valid params" do
      let(:valid_params) do
        {
          name: "Ruby on Rails",
          description: "Advanced Ruby on Rails course",
          tutors: [
            { name: "John Doe", email: "john@example.com" },
            { name: "James Smith", email: "James@example.com" }
          ]
        }
      end

      it "creates a new course with tutors" do
        expect {
          described_class.new(valid_params).call
        }.to change(Course, :count).by(1)
         .and change(Tutor, :count).by(2)
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        {
          name: "Ruby on Rails",
          description: "Advanced Ruby on Rails course",
          tutors: [
            { name: "John Doe", email: "john@example.com" },
            { name: nil, email: "jane@example.com" }
          ]
        }
      end

      it "rollbacks everything when tutor creation fails" do
        expect {
          described_class.new(invalid_params).call
        }.to raise_error(ActiveRecord::RecordInvalid)

        expect(Course.count).to eq(0)
        expect(Tutor.count).to eq(0)
      end
    end
  end
end
