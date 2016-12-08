class EquipmentWorkout < ActiveRecord::Migration[5.0]
  def change
    create_table :equipment_workouts do |t|
    
    t.string :equipment
    t.string :workout_name
    t.string :url
    
  end
  end
end
