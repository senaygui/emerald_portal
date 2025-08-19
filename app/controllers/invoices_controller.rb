class InvoicesController < ApplicationController
  before_action :set_invoice, only: %i[ show edit update destroy ]

  # GET /invoices or /invoices.json
  def index
    @invoices = current_student.invoices.all.order(created_at: :desc)
  end

  # GET /invoices/1 or /invoices/1.json
  def show
    @invoice = Invoice.find(params[:id])

    respond_to do |format|
      format.html
      format.pdf do
        pdf = InvoicePdfGenerator.new(@invoice)
        send_data pdf.render,
                  filename: "Invoice_#{@invoice.invoice_number}.pdf",
                  type: 'application/pdf',
                  disposition: 'inline' # or 'attachment' to download directly
      end
    end
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
  end

  # GET /invoices/1/edit
  def edit
  end

  def prepare_payment
    @invoice = Invoice.new
    @semester_registration = SemesterRegistration.find(params[:semester_registration_id])
  end

  def create_invoice_for_remaining_amount
    invoice = Invoice.new(invoice_params)

    respond_to do |format|
      if invoice.save
        invoice.semester_registration.update(is_back_invoice_created: true)
        format.html { redirect_to invoice_path(invoice.id), notice: "Registration was successfully created." }
        format.json { render :show, status: :ok, location: registration }
      else
        format.html { redirect_to invoices_url, alert: "Something went wrong please try again" }
        format.json { render json: registration.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @invoice = Invoice.new(invoice_params)
    respond_to do |format|
      if @invoice.save
        format.html { redirect_to @invoice, notice: "Invoice was successfully created." }
        format.json { render :show, status: :created, location: @invoice }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_invoice
    @invoice = Invoice.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def invoice_params
    params.required(:invoice).permit(:total_price, :semester_registration_id, :student_id, :department_id, :program_id, :academic_calendar_id, :year, :semester, :student_id_number, :student_full_name, :invoice_status, :invoice_number)
  end
end
