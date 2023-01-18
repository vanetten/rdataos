class CreateInsurances < ActiveRecord::Migration[7.0]
  def change
    create_table :insurances do |t|
      t.integer :age
      t.string :sex
      t.decimal :bmi
      t.integer :children
      t.string :smoker
      t.string :region
      t.decimal :charges

      t.timestamps
    end
  end
end
