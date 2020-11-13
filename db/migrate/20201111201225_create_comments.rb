class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.string :commenter
      t.text :body, null: false
      t.references :article, null: false, foreign: true

      t.timestamps
    end
  end
end
