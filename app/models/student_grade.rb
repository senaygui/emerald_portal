class StudentGrade < ApplicationRecord

  validates :student, presence: true
  validates :course, presence: true
  belongs_to :course_registration
  belongs_to :student
  belongs_to :course
  belongs_to :program, optional: true


  def moodle_grade
    url = URI('https://www.nuf.edu.et/webservice/rest/server.php')
    moodle = MoodleRb.new('ebf389740b514fdfa03fc804d767f127', 'https://www.nuf.edu.et/webservice/rest/server.php')
    lms_student = moodle.users.search(email: "#{student.email}")
    user = lms_student[0]['id']
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    form_data = [%w[wstoken ebf389740b514fdfa03fc804d767f127],
                 %w[wsfunction gradereport_overview_get_course_grades], %w[moodlewsrestformat json], ['userid', "#{user}"]]
    request.set_form form_data, 'multipart/form-data'
    response = https.request(request)
    # puts response.read_body
    results =  JSON.parse(response.read_body)
    course_code = moodle.courses.search("#{course_registration.course.course_code}")
    course = course_code['courses'][0]['id']

    total_grade = results['grades'].map { |h1| h1['rawgrade'] if h1['courseid'] == course }.compact.first
    grade_letter = results['grades'].map { |h1| h1['grade'] if h1['courseid'] == course }.compact.first
    # self.update_columns(grade_in_letter: grade_letter)
    update(assesment_total: total_grade.to_f)
  end

  def generate_grade
    return unless assesment_total.present?

    update(letter_grade: assesment_total > 50 ? 'Passed' : 'Failed')
  end
end
