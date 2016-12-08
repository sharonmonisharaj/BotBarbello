class CreateBodybuilderQuotesTable < ActiveRecord::Migration[5.0]
  def change
    
    create_table :bodybuilder_quotes do |t|
    
    t.string :name
    t.text :quote
    t.string :photo_url
    
  end
  
  end
end
