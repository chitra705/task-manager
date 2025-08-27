class PayslipsController < InheritedResources::Base

  def index
    # @payslips = SalPayslip.all
    # @payslips = SalPayslip.order(created_at: :desc)
    @payslips = SalPayslip.where("created_at >= ?", 2.months.ago).order(created_at: :desc)


  end

  def new
    @payslip = SalPayslip.new
    @payslip.payslip_values.build
  end

  def show
    @payslip = SalPayslip.find(params[:id])
     respond_to do |format|
      format.html
      format.pdf do
        render pdf: "payslip_#{@payslip.id}", template: "payslips/show_pdf", layout: 'pdf'
      end
    end
  end

  def create
    incoming_values = payslip_params
    @payslip = SalPayslip.create_payslip(incoming_values, current_user)
    redirect_to payslips_path, notice: 'Payslip successfully created.'

  end


  def download_payslips
    # @base64_image = Base64.encode64(File.read(Ikasle_Logo.png))
    @payslip = SalPayslip.all

    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"payslip_logs.csv\""
        headers['Content-Type'] ||= 'text/csv'

        csv_data = CSV.generate(headers: true) do |csv|
          csv << ['User', 'Date of Joining', 'Pay Period', 'Worked Days', 'Designation', 'Department']

          @payslip.each do |ps|
            csv << [ps.user.name, ps.user.joining_date, ps.pay_period, ps.worked_days, ps.designation, ps.department ]
          end
        end

        render plain: csv_data
      end

      format.html do
        render template: 'payslips/download_payslips'
      end
    end
  end


  private

  def payslip_params
    params.require(:sal_payslip).permit(:pay_period, :worked_days, :designation, :department,
                                    payslip_values: [:earnings, :earning_amount, :deductions, :deduction_amount])
  end

end
