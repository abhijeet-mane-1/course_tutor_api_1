require 'rails_helper'

RSpec.describe "Api::V1::Courses", type: :request do
  describe "POST /api/v1/courses" do
    let(:valid_params) do
      {
        data: {
          type: "courses",
          attributes: { name: "Ruby on Rails", description: "Advanced Ruby on Rails course" },
          relationships: {
            tutors: { 
              data: [ { type: "tutors", lid: "tutor-1" }, { type: "tutors",lid: "tutor-2" } ]
            }
          }
        },
        included: [
          { type: "tutors", lid: "tutor-1", attributes: { name: "John Doe", email: "john@example.com" }},
          { type: "tutors", lid: "tutor-2", attributes: { name: "Jane Doe", email: "jane@example.com" }}
        ]
      }
    end

    context "with valid params" do
      it "creates a course with tutors" do
        post "/api/v1/courses", params: valid_params.to_json,
          headers: {
            "CONTENT_TYPE" => "application/vnd.api+json",
            "ACCEPT" => "application/vnd.api+json"
          }
        
        body = JSON.parse(response.body)
  
        data = body["data"]
  
        expect(data["type"]).to eq("courses")
        expect(data["id"]).to be_present
  
        expect(data["attributes"]["name"]).to eq("Ruby on Rails")
        expect(data["attributes"]["description"]).to eq("Advanced Ruby on Rails course")
      end
    end

    context "with invalid params" do
      it "returns a JSON:API error when course name is missing" do
        invalid_params = valid_params.deep_dup
  
        invalid_params[:data][:attributes][:name] = nil
  
        post "/api/v1/courses",
            params: invalid_params.to_json,
            headers: {
              "CONTENT_TYPE" => "application/vnd.api+json",
              "ACCEPT" => "application/vnd.api+json"
            }
  
        expect(response).to have_http_status(:unprocessable_content)
  
        body = JSON.parse(response.body)
  
        expect(body["errors"]).to be_an(Array)
        expect(body["errors"].first["status"]).to eq("422")
        expect(body["errors"].first["code"]).to eq("VALIDATION_ERROR")
      end

      it "returns a JSON:API error when duplicate email provided" do
        invalid_params = valid_params.deep_dup
  
        invalid_params[:included][1][:attributes][:email] = invalid_params[:included][0][:attributes][:email]
  
        post "/api/v1/courses",
            params: invalid_params.to_json,
            headers: {
              "CONTENT_TYPE" => "application/vnd.api+json",
              "ACCEPT" => "application/vnd.api+json"
            }
  
        expect(response).to have_http_status(:unprocessable_content)
  
        body = JSON.parse(response.body)
  
        expect(body["errors"].first["code"]).to eq("VALIDATION_ERROR")
        expect(body["errors"].first["detail"]).to eq("Email has already been taken")
      end

      it "returns 400 when the course resource type is invalid" do
        invalid_params = valid_params.deep_dup

        invalid_params[:data][:type] = "students"

        post "/api/v1/courses",
            params: invalid_params.to_json,
            headers: {
              "CONTENT_TYPE" => "application/vnd.api+json",
              "ACCEPT" => "application/vnd.api+json"
            }

        expect(response).to have_http_status(:bad_request)

        body = JSON.parse(response.body)

        expect(body["errors"].first["code"]).to eq("BAD_REQUEST")
      end

      it "returns 400 when tutor resource type is invalid" do
        invalid_params = valid_params.deep_dup

        invalid_params[:data][:relationships][:tutors][:data][0][:type] = "students"

        post "/api/v1/courses", params: invalid_params.to_json,
            headers: {
              "CONTENT_TYPE" => "application/vnd.api+json",
              "ACCEPT" => "application/vnd.api+json"
            }

        expect(response).to have_http_status(:bad_request)

        body = JSON.parse(response.body)

        expect(body["errors"].first["code"]).to eq("BAD_REQUEST")
      end

      it "returns 400 when tutor lid is missing" do
        invalid_params = valid_params.deep_dup

        invalid_params[:data][:relationships][:tutors][:data][0].delete(:lid)

        post "/api/v1/courses",
            params: invalid_params.to_json,
            headers: {
              "CONTENT_TYPE" => "application/vnd.api+json",
              "ACCEPT" => "application/vnd.api+json"
            }

        expect(response).to have_http_status(:bad_request)

        body = JSON.parse(response.body)

        expect(body["errors"].first["code"]).to eq("BAD_REQUEST")
      end

      it "returns 400 when the referenced tutor is not included" do
        invalid_params = valid_params.deep_dup

        invalid_params[:included].delete_at(0)

        post "/api/v1/courses",
            params: invalid_params.to_json,
            headers: {
              "CONTENT_TYPE" => "application/vnd.api+json",
              "ACCEPT" => "application/vnd.api+json"
            }

        expect(response).to have_http_status(:bad_request)

        body = JSON.parse(response.body)

        expect(body["errors"].first["code"]).to eq("BAD_REQUEST")
      end

      it "returns 400 when tutor attributes are missing" do
        invalid_params = valid_params.deep_dup

        invalid_params[:included][0].delete(:attributes)

        post "/api/v1/courses",
            params: invalid_params.to_json,
            headers: {
              "CONTENT_TYPE" => "application/vnd.api+json",
              "ACCEPT" => "application/vnd.api+json"
            }

        expect(response).to have_http_status(:bad_request)

        body = JSON.parse(response.body)

        expect(body["errors"].first["code"]).to eq("BAD_REQUEST")
      end

      it "returns 400 when data is missing" do
        invalid_params = { included: []}

        post "/api/v1/courses",
            params: invalid_params.to_json,
            headers: {
              "CONTENT_TYPE" => "application/vnd.api+json",
              "ACCEPT" => "application/vnd.api+json"
            }

        expect(response).to have_http_status(:bad_request)

        body = JSON.parse(response.body)

        expect(body["errors"].first["code"]).to eq("BAD_REQUEST")
      end
    end
  end
end
