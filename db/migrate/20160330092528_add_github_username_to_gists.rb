class AddGithubUsernameToGists < ActiveRecord::Migration
  def change
    add_column :gists, :github_username, :text
  end
end
