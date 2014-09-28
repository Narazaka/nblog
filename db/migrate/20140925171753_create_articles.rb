class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.text :title
      t.datetime :created_at_display
      t.datetime :updated_at_display
      t.datetime :hide_at_display
      t.text :contents

      t.timestamps
      t.index :created_at_display
    end
  end
end
