class Lead < ApplicationRecord

	enum status:{
  	interested: 0,
  	uninterested: 1,
  	wait: 2,
  	no_response: 3
  }

	def self.upload_lead_file(file, user)
    spreadsheet = Roo::Spreadsheet.open(file.path)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      lead = Lead.new(
        status: row['Status'],
        category: row['Category'],
        category_name: row['Category Name'],
        business_name: row['Business Name'],
        address: row['Address'],
        city: row['City'],
        state: row['State'],
        postal_code: row['Postal Code'],
        country: row['Country'],
        phone: row['Phone'],
        email: row['Email'],
        website: row['Website'],
        latitude: row['Latitude'],
        longitude: row['Longitude'],
        map_link: row['Map Link'],
        details: row['details'],
        user_id:user.id,
        emp_id:user.emp.id,
      )      
      unless lead.save
        Rails.logger.error "Task could not be saved: #{task.errors.full_messages.join(', ')}"
      end
    end
  end


end
