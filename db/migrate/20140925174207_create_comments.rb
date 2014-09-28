class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :title
      t.boolean :for_only_master
      t.boolean :allow_show
      t.text :name
      t.text :url
      t.text :mail
      t.text :contents
      t.string :password_digest
      t.belongs_to :article

      t.timestamps
    end
  end
end
