class CreateContactFormSubmissions < ActiveRecord::Migration[8.0]
  def change
    create_table :contact_form_submissions do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.text :message
      t.integer :delivery_status
      t.datetime :submitted_at

      t.timestamps
    end
  end
end
