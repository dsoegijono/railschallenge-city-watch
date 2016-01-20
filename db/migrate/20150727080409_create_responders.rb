class CreateResponders < ActiveRecord::Migration
  def change
    create_table :responders, id: false, timestamps: false do |t|
      t.string  :type,                        null: false
      t.string  :name,                        null: false
      t.integer :capacity,  default: 0,       null: false
      t.boolean :on_duty,   default: false,   null: false
      t.string :emergency_code
    end
  end
end
