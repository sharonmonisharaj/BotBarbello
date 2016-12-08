class RenameBeforeafterstoriesTable < ActiveRecord::Migration[5.0]
  def change
       drop_table :beforeafter_story
     end 
   end