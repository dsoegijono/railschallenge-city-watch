class CreateEmergencies < ActiveRecord::Migration
  def change
    create_table :emergencies, id: false, timestamps: false do |t|
      t.string :code,                              null: false
      t.integer :fire_severity,                    null: false
      t.integer :police_severity,                  null: false
      t.integer :medical_severity,                 null: false
      t.timestamp :resolved_at
    end
  end
end
