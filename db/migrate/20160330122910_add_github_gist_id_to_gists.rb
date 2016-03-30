class AddGithubGistIdToGists < ActiveRecord::Migration
  def change
    add_column :gists, :github_gist_id, :string
  end
end
