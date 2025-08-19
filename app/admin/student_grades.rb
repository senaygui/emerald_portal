ActiveAdmin.register StudentGrade do
    menu parent: 'Grade'
    permit_params :course_registration_id,:student_id,:course_id,:program_id,:letter_grade,:assesment_total,:updated_by,:created_by


    member_action :generate_grade, method: :put do
      @student_grade = StudentGrade.find(params[:id])
      # @student_grade.moodle_grade
      @student_grade.generate_grade

      if @student_grade.letter_grade == "Passed" && @student_grade.program.courses.where(course_order: @student_grade.course.course_order + 1).any?
        Notification.create!(
              student_id: @student_grade.student_id,
              notifiable: @student_grade,
              notification_status: 'success',
              notification_message: "Congratulations!!! You have successfully Passed this course (#{@student_grade.course.course_title}). Enroll To the next course to continue your learning journey.",
              notification_card_color: "success",
              notification_action: "create"
          )
      elsif @student_grade.letter_grade == "Failed"
        Notification.create!(
              student_id: @student_grade.student_id,
              notifiable: @student_grade,
              notification_status: 'danger',
              notification_message: "Unfortunately, you have failed the course (#{@student_grade.course.course_title}). Please review your performance and consider retaking the course.",
              notification_card_color: "danger",
              notification_action: "failed"
          )
      else
        Notification.create!(
              student_id: @student_grade.student_id,
              notifiable: @student_grade,
              notification_status: 'success',
              notification_message: "Congratulations!!! You have successfully Passed this course (#{@student_grade.course.course_title}). You have completed all the course. you can now request and get your certficate",
              notification_card_color: "success",
              notification_action: "completed"
          )
        @student_grade.student.update(graduation_status:"graduated",fully_attended_date: Time.now)
      end
      redirect_back(fallback_location: admin_student_grade_path)
    end

    batch_action :generate_grade, confirm: "Are you sure you want to generate grades for the selected students?" do |selection|
      StudentGrade.where(id: selection).find_each do |student_grade|
        # student_grade.moodle_grade
        student_grade.generate_grade
        if student_grade.letter_grade == "Passed" && student_grade.program.courses.where(course_order: student_grade.course.course_order + 1).any?
          Notification.create!(
                student_id: student_grade.student_id,
                notifiable: student_grade,
                notification_status: 'success',
                notification_message: "Congratulations!!! You have successfully Passed this course (#{student_grade.course.course_title}). Enroll To the next course to continue your learning journey.",
                notification_card_color: "success",
                notification_action: "create"
            )
        elsif student_grade.letter_grade == "Failed"
          Notification.create!(
                student_id: student_grade.student_id,
                notifiable: student_grade,
                notification_status: 'danger',
                notification_message: "Unfortunately, you have failed the course (#{student_grade.course.course_title}). Please review your performance and consider retaking the course.",
                notification_card_color: "danger",
                notification_action: "failed"
            )
        else
          Notification.create!(
                student_id: student_grade.student_id,
                notifiable: student_grade,
                notification_status: 'success',
                notification_message: "Congratulations!!! You have successfully Passed this course (#{student_grade.course.course_title}). You have completed all the course. you can now request and get your certficate",
                notification_card_color: "success",
                notification_action: "completed"
            )
          student_grade.student.update(graduation_status:"graduated")
        end
      end
      redirect_back(fallback_location: collection_path, notice: "Grades generated for selected students.")
    end

    index do
      selectable_column
      column 'Full Name', sortable: 'students.first_name' do |n|
        [n.student.first_name, n.student.middle_name, n.student.last_name].compact.join(' ')
      end
      column 'Student ID' do |si|
        si.student.student_id
      end
      column 'Program' do |si|
        si.student.program.program_name
      end
      column 'Course title' do |si|
        si.course.course_title
      end
      column :letter_grade
      column :assesment_total
      column 'Created At', sortable: true do |c|
        c.created_at.strftime('%b %d, %Y')
      end
      actions
    end

    filter :student_id, as: :search_select_filter, url: proc { admin_students_path },
                        fields: %i[student_id id], display_name: 'student_id', minimum_input_length: 2,
                        order_by: 'created_at_asc'
    filter :course_id, as: :search_select_filter, url: proc { admin_courses_path },
                       fields: %i[course_title id], display_name: 'course_title', minimum_input_length: 2,
                       order_by: 'created_at_asc'
    filter :program_id, as: :search_select_filter, url: proc { admin_programs_path },
                        fields: %i[program_name id], display_name: 'program_name', minimum_input_length: 2,
                        order_by: 'created_at_asc'
    filter :letter_grade
    filter :assesment_total
    filter :created_at
    filter :updated_at
    filter :updated_by
    filter :created_by

    form title: proc { |student| student.student.full_name if student.student.present? } do |f|
      f.semantic_errors
      f.inputs 'Student Grade' do
        f.input :student_id, as: :search_select, url: proc { admin_students_path },
                             fields: %i[student_id id], display_name: 'student_id', minimum_input_length: 2,
                             order_by: 'created_at_asc'
        f.input :course_id, as: :search_select, url: proc { admin_courses_path },
                            fields: %i[course_title id], display_name: 'course_title', minimum_input_length: 2,
                            order_by: 'created_at_asc'
        f.input :program_id, as: :search_select, url: proc { admin_programs_path },
                             fields: %i[program_name id], display_name: 'program_name', minimum_input_length: 2,
                             order_by: 'created_at_asc'
        f.input :assesment_total
        f.input :letter_grade, as: :select, collection: %w[Passed Failed]
      end
      if f.object.new_record?
        f.input :created_by, input_html: { value: current_admin_user.name }, as: :hidden
      else
        f.input :updated_by, input_html: { value: current_admin_user.name }, as: :hidden
      end
      f.actions
    end


    show title: proc { |student| student.student.full_name } do
      columns do
        column do
          panel 'Grade information' do
            attributes_table_for student_grade do
              row 'full name', sortable: true do |n|
                n.student.full_name
              end
              row 'Student ID' do |si|
                si.student.student_id
              end
              row 'Course title' do |si|
                si.course.course_title
              end
              row 'Program' do |pr|
                link_to pr.student.program.program_name, admin_program_path(pr.student.program.id)
              end
              row :created_at
              row :updated_at
            end
          end
        end
        column do
          panel 'Grade information' do
            attributes_table_for student_grade do
              row :letter_grade
              row :assesment_total
            end
          end
          panel 'Actions' do
            attributes_table_for student_grade do
              row 'Generate Grade' do
                link_to 'Generate Grade', generate_grade_admin_student_grade_path(student_grade), method: :put, class: 'btn btn-primary'
              end
            end
          end
        end
      end
    end
end
