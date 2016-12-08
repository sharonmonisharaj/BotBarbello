class NewBeforeafterTable < ActiveRecord::Migration[5.0]
  def change
    
    create_table :beforeafters do |t|
    
    t.string :name
    t.text :story
    t.string :photo_url
    
  end
  
  end
end
