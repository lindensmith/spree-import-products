require 'spec_helper'

feature "Import products" do
  background do
    sign_in_as! Factory(:admin_user)
  end

  scenario "admin should be able to import products and delete import" do
    visit spree.admin_product_imports_path
    attach_file("product_import_data_file", File.join(File.dirname(__FILE__), '..', 'fixtures', 'valid.csv'))
    click_button "Create"

    page.should have_content("valid.csv")
    page.should have_content("Created")

    Delayed::Worker.new.work_off

    visit spree.admin_product_imports_path
    page.should have_content("valid.csv")
    page.should have_content("Completed")
    click_link "Show"
    page.should have_content("S0388G-bloch-kids-tap-flexewe")
    # click_link "Destroy"
    save_and_open_page
  end

end