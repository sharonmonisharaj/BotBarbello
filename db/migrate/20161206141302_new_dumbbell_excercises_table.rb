class NewDumbbellExcercisesTable < ActiveRecord::Migration[5.0]
  def change
    
    create_table :dumbbell_exercises do |t|
    
    t.string :dumbbell
    
  end
  
  end
end
