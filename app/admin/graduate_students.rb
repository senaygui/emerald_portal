ActiveAdmin.register Student, as: 'GraduateStudent' do
   menu parent: 'Student Management', priority: 1
   actions :all, except: [:destroy, :edit]

  # Permitted parameters for create/update
  permit_params :first_name, :middle_name, :last_name, :email, :password, :password_confirmation,
                :gender, :date_of_birth, :place_of_birth, :moblie_number, :alternative_moblie_number,
                :country, :region, :city, :photo, :program_id, :batch_id, :account_status,
                :graduation_status, :fully_attended, :fully_attended_date, :sponsorship_status,
                :student_id, :student_password, :created_by, :last_updated_by, :photo

  # Filters
  filter :student_id
  filter :email
  filter :first_name
  filter :last_name
  filter :program_id, as: :search_select_filter, url: proc { admin_programs_path },
                      fields: %i[program_name id], display_name: 'program_name', minimum_input_length: 2,
                      order_by: 'created_at_asc'
  filter :batch_id, as: :search_select_filter, url: proc { admin_batches_path },
                      fields: %i[batch_title id], display_name: 'batch_title', minimum_input_length: 2,
                      order_by: 'created_at_asc'
  filter :gender, as: :select, collection: %w[Male Female Other]
  filter :account_status, as: :select, collection: %w[active inactive suspended]
  filter :created_at

  # Scopes
  scope :all, default: true
  scope :active
  scope :inactive
  scope :suspended
  scope :recently_added

  # Index page
  index do
    selectable_column
    column :student_id
    column :full_name
    column :email
    column :gender
    column :program do |m|
      link_to m.program.program_name, [:admin, m.program] if m.program
    end
    column :batch do |m|
      link_to m.batch.batch_title, [:admin, m.batch] if m.batch
    end
    column :account_status do |student|
      status_tag student.account_status, class: (student.account_status == 'active' ? 'ok' : 'warning')
    end
    column :created_at
    actions
  end

  action_item :edit, only: :show, priority: 0 do
    link_to 'Student Certifcate', student_tempo_graduate_student_path(graduate_student, format: :pdf)
  end
  action_item :mark_fully_attended, only: :show do
    if graduate_student.fully_attended.to_s != 'completed'
      link_to 'Mark Fully Attended', mark_fully_attended_admin_graduate_student_path(graduate_student), method: :put, data: { confirm: 'Mark this student as fully attended?' }
    end
  end
  # Show page
  show do
    columns do
      column do
        panel 'Photo' do
          if graduate_student.photo.attached?
            div style: 'display: flex; justify-content: center; align-items: center;' do
              image_tag graduate_student.photo.variant(resize_to_limit: [200, 200]),
                        style: 'border-radius: 10%; box-shadow: 0 2px 8px #eee;'
            end
          else
            div style: 'display: flex; justify-content: center; align-items: center;' do
              image_tag 'https://via.placeholder.com/200x200.png?text=LOGO+PLACEHOLDER',
                        style: 'border-radius: 50%; box-shadow: 0 2px 8px #eee;'
            end
          end
        end
        panel 'Personal Information' do
          attributes_table_for graduate_student do
            row :student_id
            row :first_name
            row :middle_name
            row :last_name
            row :gender
            row :date_of_birth
            row :age
            row :place_of_birth
          end
        end
        panel 'Contact Information' do
          attributes_table_for graduate_student do
            row :moblie_number
            row :alternative_moblie_number
            row :country
            row :region
            row :city
          end
        end
      end
      column do
        panel 'Academic Information' do
          attributes_table_for graduate_student do
            row :program do |m|
              link_to m.program.program_name, [:admin, m.program] if m.program
            end
            row :batch do |m|
              link_to m.batch.batch_title, [:admin, m.batch] if m.batch
            end
            row :graduation_status
            row :fully_attended
            row :fully_attended_date
            row :sponsorship_status
          end
        end
        panel 'Account Status' do
          attributes_table_for graduate_student do
            row :account_status do |s|
              status_tag s.account_status, class: (s.account_status == 'active' ? 'ok' : 'warning')
            end
            row :created_by
            row :last_updated_by
            row :created_at
            row :updated_at
            row :sign_in_count
            row :current_sign_in_at
            row :last_sign_in_at
            row :current_sign_in_ip
            row :last_sign_in_ip
          end
        end
        panel 'Student Courses' do
          table_for graduate_student.student_courses do
            column :course do |sc|
              sc.course&.course_title || sc.course_title
            end
            column :course do |sc|
              sc.course&.course_order || sc.course_order
            end
            column :created_by do |sc|
              sc.created_by || 'system'
            end
            column :created_at
          end
        end
        panel 'Invoices' do
          table_for graduate_student.invoices do
            column :invoice_number
            column :program do |m|
              link_to m.program.program_name, [:admin, m.program] if m.program
            end
            column :batch do |m|
              link_to m.batch.batch_title, [:admin, m.batch] if m.batch
            end
            column :total_price
            column :invoice_status
            column :due_date
          end
        end
      end
    end
  end

  # Form for new/edit
  form do |f|
    f.semantic_errors
    f.inputs 'Account Status' do
      f.input :account_status, as: :select, collection: %w[active inactive suspended]
      f.input :graduation_status
      f.input :fully_attended
      f.input :fully_attended_date, as: :datepicker
    end
    if f.object.new_record?
      f.input :created_by, input_html: { value: current_admin_user.name }, as: :hidden
    else
      f.input :last_updated_by, input_html: { value: current_admin_user.name }, as: :hidden
    end
    f.actions
  end

  # Member action to mark student as fully attended
  member_action :mark_fully_attended, method: :put do
    if resource.update(fully_attended: 'completed', fully_attended_date: Date.current, last_updated_by: current_admin_user.name)
      redirect_to resource_path, notice: 'Student marked as fully attended.'
    else
      redirect_to resource_path, alert: 'Failed to update fully attended status.'
    end
  end

  controller do
    def update_resource(object, attributes)
      update_method = attributes.first[:password].present? ? :update : :update_without_password
      object.send(update_method, *attributes)
    end

    def scoped_collection
      super.where(graduation_status: 'graduated') # adjust 'status' if the column is named differently
    end
  end
end