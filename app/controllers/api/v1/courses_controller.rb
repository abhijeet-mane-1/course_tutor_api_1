class Api::V1::CoursesController < ApplicationController
  include Api::ErrorHandler

  def create
    course_params = JsonApi::CourseCreateParams.new(params).call

    course = CourseCreateService.new(course_params).call

    render json: course,
          serializer: CourseSerializer,
          adapter: :json_api,
          status: :created
  end
end
