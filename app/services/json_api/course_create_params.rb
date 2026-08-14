module JsonApi
  class CourseCreateParams
    COURSE_TYPE = "courses"
    TUTOR_TYPE = "tutors"

    def initialize(params)
      @params = params
    end

    def call
      validate_resource_type!

      {
        name: course_attributes[:name],
        description: course_attributes[:description],
        tutors: tutor_attributes
      }
    end

    private

    attr_reader :params

    def validate_resource_type!
      unless params.dig(:data, :type) == COURSE_TYPE
        raise ActionController::BadRequest, "Invalid resource type"
      end
    end

    def course_attributes
      @course_attributes ||= begin
        data = params.require(:data)
        attributes = data.require(:attributes)

        {
          name: attributes[:name],
          description: attributes[:description]
        }
      end
    end

    def tutor_attributes
      tutor_relationships.map do |relationship|
        validate_tutor_relationship!(relationship)

        tutor = find_included_tutor(relationship[:lid])

        unless tutor
          raise ActionController::BadRequest, "Included tutor not found for lid: #{relationship[:lid]}"
        end

        attributes = tutor[:attributes]

        unless attributes
          raise ActionController::BadRequest, "Tutor attributes are missing"
        end

        {
          name: attributes[:name],
          email: attributes[:email]
        }
      end
    end

    def tutor_relationships
      relationships = params.dig(
        :data,
        :relationships,
        :tutors,
        :data
      )

      return [] if relationships.nil?

      unless relationships.is_a?(Array)
        raise ActionController::BadRequest, "Tutor relationship data must be an array"
      end

      relationships
    end

    def validate_tutor_relationship!(relationship)
      unless relationship[:type] == TUTOR_TYPE
        raise ActionController::BadRequest, "Invalid tutor resource type"
      end

      if relationship[:lid].blank?
        raise ActionController::BadRequest, "Tutor relationship lid is required"
      end
    end

    def find_included_tutor(lid)
      params[:included]&.find do |resource|
        resource[:type] == TUTOR_TYPE && resource[:lid] == lid
      end
    end
  end
end
