class RenameBeforeafterstorysTable < ActiveRecord::Migration[5.0]
  def change
    rename_table :beforeafter_storys, :beforeafter_stories
  end
end
