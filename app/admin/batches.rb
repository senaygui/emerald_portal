ActiveAdmin.register Batch do
  permit_params :batch_title, :program_id, :starting_date, :ending_date, :total_number_of_students, :created_by,
                :last_updated_by

  # includes :students, :course_registrations, :invoices

  index do
    selectable_column
    column :batch_title
    column :program do |m|
      link_to m.program.program_name, [:admin, m.program] if m.program
    end
    column :starting_date
    column :ending_date
    column :total_number_of_students
    column :created_by
    column :last_updated_by
    actions
  end

  filter :batch_title
  filter :program_id, as: :search_select_filter, url: proc { admin_programs_path },
                      fields: %i[program_name id], display_name: 'program_name', minimum_input_length: 2,
                      order_by: 'created_at_asc'
  filter :starting_date
  filter :ending_date
  filter :total_number_of_students
  filter :created_by
  filter :last_updated_by
  filter :created_at
  filter :updated_at

  form do |f|
    f.semantic_errors
    f.inputs 'Batch Information' do
      f.input :batch_title
      f.input :program_id, as: :select, collection: Program.all.map { |p|
                                                      [p.program_name, p.id]
                                                    }, include_blank: 'Select Program'
      f.input :starting_date, as: :datepicker
      f.input :ending_date, as: :datepicker
      f.input :total_number_of_students
      f.input :created_by, input_html: { value: current_admin_user.name }, as: :hidden
      f.input :last_updated_by, input_html: { value: current_admin_user.name }, as: :hidden
    end
    f.actions
  end

  show title: :batch_title do
    attributes_table do
      row :program do |m|
        link_to m.program.program_name, [:admin, m.program] if m.program
      end
      row :batch_title
      row :starting_date
      row :ending_date
      row :total_number_of_students
      row :created_by
      row :last_updated_by
      row :created_at
      row :updated_at
    end
    panel 'Students' do
      table_for batch.students do
        column :full_name
        column :email
        column :created_at
      end
    end
  end

  controller do
    def create
      params[:batch][:created_by] = current_admin_user.name
      params[:batch][:last_updated_by] = current_admin_user.name
      super
    end

    def update
      params[:batch][:last_updated_by] = current_admin_user.name
      super
    end
  end
end
