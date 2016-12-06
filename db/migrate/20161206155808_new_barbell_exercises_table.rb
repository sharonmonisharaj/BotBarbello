class NewBarbellExercisesTable < ActiveRecord::Migration[5.0]
  def change
    
    create_table :barbell_exercises do |t|
    
    t.string :name
    t.string :barbell
    
  end
  end
end
