class CourseCreateService
  def initialize(course_params)
    @course_params = course_params
  end

  def call
    Course.transaction do
      course = create_course
      create_tutors(course)

      course
    end
  end

  private

  attr_reader :course_params

  def create_course
    Course.create!(
      name: course_params[:name],
      description: course_params[:description]
    )
  end

  def create_tutors(course)
    course_params[:tutors].each do |tutor_params|
      course.tutors.create!(
        name: tutor_params[:name],
        email: tutor_params[:email]
      )
    end
  end
end
