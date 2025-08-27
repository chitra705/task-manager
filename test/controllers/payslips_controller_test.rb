require "test_helper"

class PayslipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @payslip = payslips(:one)
  end

  test "should get index" do
    get payslips_url
    assert_response :success
  end

  test "should get new" do
    get new_payslip_url
    assert_response :success
  end

  test "should create payslip" do
    assert_difference("Payslip.count") do
      post payslips_url, params: { payslip: {  } }
    end

    assert_redirected_to payslip_url(Payslip.last)
  end

  test "should show payslip" do
    get payslip_url(@payslip)
    assert_response :success
  end

  test "should get edit" do
    get edit_payslip_url(@payslip)
    assert_response :success
  end

  test "should update payslip" do
    patch payslip_url(@payslip), params: { payslip: {  } }
    assert_redirected_to payslip_url(@payslip)
  end

  test "should destroy payslip" do
    assert_difference("Payslip.count", -1) do
      delete payslip_url(@payslip)
    end

    assert_redirected_to payslips_url
  end
end
