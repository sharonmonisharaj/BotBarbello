class NewCardioExercisesTable < ActiveRecord::Migration[5.0]
  def change
    
    create_table :cardio_exercises do |t|
    
    t.string :name
    t.string :cardio
    
  end
end
