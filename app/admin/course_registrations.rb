ActiveAdmin.register CourseRegistration do
  menu parent: 'Student Management', priority: 1
  config.batch_actions = true


  controller do
    def scoped_collection
      super.where("enrollment_status = ?", "enrolled")
    end
  end

  batch_action "Generate Grade Sheet", method: :put, confirm: "Are you sure?" do |ids|
    CourseRegistration.find(ids).each do |course_registration|
      course_registration.add_grade
    end
    redirect_to collection_path, notice: "Grade Sheet Is Generated Successfully"
  end

  # Filters
  filter :student_full_name
  filter :student_id
  filter :program, as: :select, collection: -> { Program.all.map { |p| [p.program_name, p.id] } }
  filter :batch, as: :select, collection: -> { Batch.all.map { |b| [b.batch_title, b.id] } }
  filter :course_title
  filter :enrollment_status, as: :select, collection: ['pending', 'enrolled', 'dropped']
  filter :created_at

  # Scopes
  scope :all, default: true
  scope :enrolled do |registrations|
    registrations.where(enrollment_status: 'enrolled')
  end
  scope :pending do |registrations|
    registrations.where(enrollment_status: 'pending')
  end
  scope :dropped do |registrations|
    registrations.where(enrollment_status: 'dropped')
  end

  index do
    selectable_column
    column "Student Name" do |s|
      s.student_full_name
    end
    column :program do |m|
      link_to m.program.program_name, [:admin, m.program] if m.program
    end
    column :batch do |m|
      link_to m.batch.batch_title, [:admin, m.batch] if m.batch
    end
    column :student_id do |c|
      c.student.student_id
    end
    column :course_title
    column :program do |c|
      c.program.program_name
    end
    column :enrollment_status
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end
end
