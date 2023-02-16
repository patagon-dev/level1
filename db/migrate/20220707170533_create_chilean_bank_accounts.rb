class CreateChileanBankAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :chilean_bank_accounts do |t|
      t.string :first_name
      t.string :last_name
      t.string :bank_name
      t.string :bank_rut
      t.string :bank_account
      t.string :payment_notification_email
      t.string :person_id

      t.timestamps
    end

    add_index :chilean_bank_accounts, :person_id
  end
end
