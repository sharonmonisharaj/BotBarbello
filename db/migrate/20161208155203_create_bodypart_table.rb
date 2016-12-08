class CreateBodypartTable < ActiveRecord::Migration[5.0]
  def change
    
    create_table :body_parts do |t|
    
    t.string :body_part
    t.string :workout_name
    t.string :url
    
  end
  
  end
end
