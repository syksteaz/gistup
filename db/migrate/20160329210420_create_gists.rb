class CreateGists < ActiveRecord::Migration
  def change
    create_table :gists do |t|
      t.text :name
      t.text :description
      t.text :content
      t.boolean :public

      t.timestamps null: false
    end
  end
end
