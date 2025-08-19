ActiveAdmin.register Program do
  permit_params :program_name, :program_code, :overview, :program_description, :total_tuition, :created_by,
                :last_updated_by

  includes :courses, :students, :course_registrations

  index do
    selectable_column
    column :program_name
    column :program_code
    column 'Courses' do |program|
      program.courses.count
    end
    column 'Students' do |program|
      program.students.count
    end
    column 'Total Tuition' do |program|
      number_to_currency(program.total_tuition, unit: 'ETB ', separator: '.', delimiter: ',', format: '%n %u')
    end
    column 'Created At' do |program|
      program.created_at.strftime('%b %d, %Y')
    end
    actions
  end

  filter :program_name
  filter :program_code
  filter :created_by
  filter :last_updated_by
  filter :created_at
  filter :updated_at

  scope :recently_added
  scope :all, default: true

  form do |f|
    f.semantic_errors
    f.inputs 'Program Information' do
      f.input :program_name
      f.input :program_code
      f.input :overview, as: :text
      f.input :program_description, as: :text, input_html: { rows: 5 }
      f.input :total_tuition
      f.
      f.input :created_by, input_html: { value: current_admin_user.name }, as: :hidden
      f.input :last_updated_by, input_html: { value: current_admin_user.name }, as: :hidden
    end
    f.actions
  end

  show title: :program_name do
    tabs do
      tab 'Program Details' do
        columns do
          column min_width: '70%' do
            attributes_table do
              row :program_name
              row :program_code
              row :overview
              row :program_description
              row 'Total Tuition' do |p|
                number_to_currency(p.total_tuition, unit: 'ETB ', separator: '.', delimiter: ',', format: '%n %u')
              end
              row :created_by
              row :last_updated_by
              row :created_at
              row :updated_at
            end
          end
          column max_width: '27%' do
            panel 'Program Statistics' do
              attributes_table_for program do
                row 'Number of Courses' do |p|
                  p.courses.count
                end
                row 'Number of Students' do |p|
                  p.students.count
                end
                row 'Total Registrations' do |p|
                  p.course_registrations.count
                end
              end
            end
            
            panel 'Batches' do
              if program.students.any?
                attributes_table_for program.students.group(:batch).order('count_all DESC').count do
                  row 'Batch' do |batch_count|
                    batch_count[0] || 'No Batch'
                  end
                  row 'Students' do |batch_count|
                    batch_count[1]
                  end
                end
              else
                para 'No students in any batch', class: 'no-batches'
              end
            end
          end
        end
      end

      tab 'Courses' do
        panel 'Course List' do
          table_for program.courses.order(:course_order) do
            column 'Order', :course_order
            column 'Course Code' do |course|
              link_to course.course_code, admin_course_path(course)
            end
            column 'Course Title' do |course|
              link_to course.course_title, admin_course_path(course)
            end
            column 'Start Date' do |course|
              course.course_starting_date&.strftime('%b %d, %Y')
            end
            column 'End Date' do |course|
              course.course_ending_date&.strftime('%b %d, %Y')
            end
            column 'Price' do |course|
              number_to_currency(course.course_price, unit: 'ETB ', separator: '.', delimiter: ',', format: '%n %u')
            end
            column 'Status' do |course|
              status_tag(course.course_ending_date && course.course_ending_date < Time.now ? 'Completed' : 'Active')
            end
          end
        end
      end
    end
  end

  controller do
    def create
      params[:program][:created_by] = current_admin_user.name
      params[:program][:last_updated_by] = current_admin_user.name
      super
    end

    def update
      params[:program][:last_updated_by] = current_admin_user.name
      super
    end
  end
end
