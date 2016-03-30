class AddCategoriesToGists < ActiveRecord::Migration
  def change
    add_column :gists, :categories, :string, array: true, default: []
  end
end
