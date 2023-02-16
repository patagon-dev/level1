# == Schema Information
#
# Table name: chilean_bank_accounts
#
#  id                         :bigint           not null, primary key
#  first_name                 :string(255)
#  last_name                  :string(255)
#  bank_name                  :string(255)
#  bank_rut                   :string(255)
#  bank_account               :string(255)
#  payment_notification_email :string(255)
#  person_id                  :string(255)
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#
# Indexes
#
#  index_chilean_bank_accounts_on_person_id  (person_id)
#

class ChileanBankAccount < ApplicationRecord
  validates_presence_of :first_name, :last_name, :bank_name, :bank_account, :payment_notification_email
  validates :bank_rut, presence: true, rut: true

  belongs_to :person
  def self.bank_names
    [
      'Banco Santander',
      'Banco BICE',
      'Banco Internacional',
      'Banco Itaú',
      'Banco de Chile',
      'Corpbanca',
      'Banco Crédito e Inversiones',
      'Banco del Desarrollo',
      'Banco Estado',
      'Banco Falabella',
      'Banco Security',
      'Scotiabank',
      'Rabobank',
      'HSBC Bank',
      'Banco Ripley',
      'Banco Paris',
      'Banco Consorcio',
      'Coopeuch'
    ]   
  end
end
