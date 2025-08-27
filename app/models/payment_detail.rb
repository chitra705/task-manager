class PaymentDetail < ApplicationRecord
	
	belongs_to :user
	belongs_to :emp
  has_one_attached :details_img


  def update_payment(pd_id, given_amount, details_img)
  	ga = given_amount.to_i
  	pd = PaymentDetail.find_by(id:pd_id)
  	pd.given_amount += ga if given_amount.present?

    if details_img.present?
      pd.details_img.attach(details_img)
    end

    pd.save!


  end

end
