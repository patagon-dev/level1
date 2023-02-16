class AddBaseCurrencyAndExchangeRateToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :base_currency, :string, after: :unit_price_currency
    add_column :transactions, :exchange_rate, :float, after: :base_currency, default: 0

    # Update all exiting listing to base currency, i.e CLP
    Listing.find_each do |listing|
      listing.update_column(:currency, Community::LOCAL_CURRENCY)
    end
  end
end
