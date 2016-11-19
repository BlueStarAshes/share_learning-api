# frozen_string_literal: true

# Loads data from Facebook group to database
class LoadCoursesFromAPI
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :retrieve_udacity_courses, lambda { |udacity_api|
    begin
      udacity_courses = Udacity::UdacityCourse.find.acquire_all_courses
      Right(udacity_courses)
    rescue
      Left(Error.new(:bad_request, 'Cannot retrieve Udacity courses'))
    end
  }

  register :retrieve_coursera_courses, lambda { |coursera_api|
    begin
      coursera_courses = Coursera::CourseraCourses.find.courses
      Right(coursera_courses)
    rescue
      Left(Error.new(:bad_request, 'Cannot retrieve Coursera courses'))
    end
  }

  register :create_udacity_courses, lambda { |udacity_courses|
    begin
      udacity_courses.each do |course|
        Course.create(
          title: course[:title],
          source: 'Udacity',
          original_source_id: course[:id],
          introduction: course[:intro], 
          link: course[:link], 
          photo: course[:image]
        )
      end
      Right('Add courses finish')
    rescue
      Left(Error.new(:bad_request, 'Cannot create Udacity courses'))
    end      
  }  

  register :create_coursera_courses, lambda { |coursera_courses|
     begin 
      coursera_courses.each do |item|
        item.each.with_index do |course, index| 
          if index == 1
            Course.create(
              title: course[:course_name],
              source: 'Coursera',
              original_source_id: course[:course_id],
              introduction: course[:description], 
              link: course[:link], 
              photo: course[:photo_url]
            )  
          end
        end
      end
      Right('Add courses finish')
    rescue
      Left(Error.new(:bad_request, 'Cannot create Coursera courses'))
    end      
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :retrieve_udacity_courses
      step :create_udacity_courses      
      step :retrieve_coursera_courses
      step :create_coursera_courses
    end.call(params)
  end 
end