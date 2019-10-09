class CreateRates < ActiveRecord::Migration[6.0]
  def change
    create_table :rates do |t|
      t.string :currency_1
      t.string :currency_2
      t.decimal :rate

      t.timestamps
    end
  end
end
