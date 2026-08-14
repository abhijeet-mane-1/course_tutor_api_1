class Api::V1::CoursesController < ApplicationController
  include Api::ErrorHandler
  include Api::Paginatable

  def index
    courses = Course
      .includes(:tutors)
      .order(:id)
      .offset(pagination_offset)
      .limit(per_page)

    render json: courses,
           each_serializer: CourseSerializer,
           adapter: :json_api,
           include: ["tutors"],
           meta: pagination_meta(Course.count),
           status: :ok
  end

  def create
    course_params = JsonApi::CourseCreateParams.new(params).call

    course = CourseCreateService.new(course_params).call

    render json: course,
          serializer: CourseSerializer,
          adapter: :json_api,
          status: :created
  end
end
