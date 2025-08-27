require "application_system_test_case"

class PayslipsTest < ApplicationSystemTestCase
  setup do
    @payslip = payslips(:one)
  end

  test "visiting the index" do
    visit payslips_url
    assert_selector "h1", text: "Payslips"
  end

  test "should create payslip" do
    visit payslips_url
    click_on "New payslip"

    click_on "Create Payslip"

    assert_text "Payslip was successfully created"
    click_on "Back"
  end

  test "should update Payslip" do
    visit payslip_url(@payslip)
    click_on "Edit this payslip", match: :first

    click_on "Update Payslip"

    assert_text "Payslip was successfully updated"
    click_on "Back"
  end

  test "should destroy Payslip" do
    visit payslip_url(@payslip)
    click_on "Destroy this payslip", match: :first

    assert_text "Payslip was successfully destroyed"
  end
end
