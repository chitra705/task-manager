class PaymentDetailsController < ApplicationController

	def index
    @payment_details = PaymentDetail.where(created_at: Time.current.beginning_of_month..Time.current.end_of_month)
  end

  def show
    @payment_detail = PaymentDetail.find(params[:id])
  end


  def delete_pd
	  pd = PaymentDetail.find_by(id: params[:id])

	  if pd
	    pd.destroy
	    redirect_to payment_details_path, notice: 'Payment detail deleted successfully.'
	  else
	    redirect_to payment_details_path, alert: 'Payment detail not found.'
	  end
	end

	def given_update
    @payment_detail = PaymentDetail.find(params[:id])

    if @payment_detail.update_payment(params[:id], params[:given_amount], params[:details_img])
      flash[:notice] = "Payment detail updated successfully."
    else
      flash[:alert] = "Failed to update payment detail."
    end

    redirect_to payment_details_path
  end


  def delete_details_img
    @payment_detail = PaymentDetail.find(params[:id])
    @payment_detail.details_img.purge
    redirect_to @payment_detail, notice: 'Image deleted successfully!'
  end

  private

  def payment_detail_params
    params.require(:payment_detail).permit(:given_amount, :details_img)
  end

end
