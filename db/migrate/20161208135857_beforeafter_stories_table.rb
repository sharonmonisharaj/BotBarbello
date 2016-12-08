class BeforeafterStoriesTable < ActiveRecord::Migration[5.0]
  def change
    
    create_table :beforeafter_stories do |t|
    
    t.string :name
    t.text :story
    t.string :photo_url
    
  end
  
  end
end
