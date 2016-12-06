class AddNameColumnToDumbbellExercisesTable < ActiveRecord::Migration[5.0]
  def change
    
    add_column :dumbbell_exercises, :name, :string
    
  end
end
