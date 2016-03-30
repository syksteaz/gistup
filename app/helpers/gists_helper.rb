module GistsHelper
  def find_gist_categories(gist_id)
    gist = Gist.find_by_github_gist_id(gist_id)
    gist.nil? ? [""] : gist.categories
  end
end
