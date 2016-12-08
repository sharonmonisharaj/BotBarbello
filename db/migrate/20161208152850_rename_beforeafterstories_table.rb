class RenameBeforeafterstoriesTable < ActiveRecord::Migration[5.0]
  def change
       rename_table :beforeafter_stories, :beforeafter_storys
     end 
   end