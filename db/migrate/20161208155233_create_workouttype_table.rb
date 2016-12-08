class CreateWorkouttypeTable < ActiveRecord::Migration[5.0]
  def change
    
    create_table :workout_types do |t|
    
    t.string :workout_type
    t.string :workout_name
    t.string :url
    
  end
  
  end
end
