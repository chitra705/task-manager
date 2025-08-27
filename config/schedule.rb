every '*/1 * * * *' do
  runner "UpdateActiveTimeJob.perform_later"
end

every '0 0 1 * *' do
  rake "payment_details:create_payment"
end


