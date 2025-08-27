class LeadsController < ApplicationController
  before_action :set_lead_task, only: [:edit, :update]

	def index
    @categories = Lead.pluck(:category).uniq
    if params[:category].present?
      @leads = Lead.where(category: params[:category]).page(params[:page]).per(10)
    else
      @leads = Lead.all.page(params[:page]).per(10)
    end
  end

  def new
    @leads = Lead.new    
  end

  def edit
    @leads = Lead.find(params[:id])
  end

  def show
    @lead = Lead.find(params[:id])
  end

  def update
    authorize @leads
    if @leads.update(lead_params)
      redirect_to leads_path, notice: 'Lead was successfully updated.'
    else
      render :edit
    end
  end
  
  def upload_file
    file = params[:file]
    if file.present?
      Lead.upload_lead_file(file, current_user)
      redirect_to leads_path, notice: "leads successfully uploaded."
    else
      redirect_to leads_path, alert: "Please upload a valid Excel file."
    end
  end

  def lead_delete
  	lead = Lead.find(params[:id])
    if lead.delete
      flash[:alert] = 'lead was successfully destroyed.'
      redirect_to leads_path, alert: 'destroy the lead.'
 
    else
      redirect_to leads_path, alert: 'Failed to destroy the project task.'
    end
  end

  private

  def set_lead_task
    @leads = Lead.find_by(id: params[:id])
    if @leads.nil?
      flash[:alert] = 'Lead not found.'
      redirect_to leads_path
    end
  end

  def lead_params
	  params.require(:lead).permit(
	    :user_id,
	    :emp_id,
	    :status,
	    :category,
	    :category_name,
	    :business_name,
	    :address,
	    :city,
	    :state,
	    :postal_code,
	    :country,
	    :email,
	    :website,
	    :latitude,
	    :longitude,
	    :map_link,
	    :details,
	    :phone
	  )
	end





end
