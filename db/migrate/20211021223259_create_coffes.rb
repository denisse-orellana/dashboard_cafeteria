class CreateCoffes < ActiveRecord::Migration[5.2]
  def change
    create_table :coffes do |t|
      t.string :name
      t.integer :price
      t.string :origin
      t.string :blend

      t.timestamps
    end
  end
end
