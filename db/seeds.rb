require 'open-uri'

base_url = 'https://www.bbcgoodfood.com'
collections = %w[ batch-cooking
                  cheap-eats
                  healthy-breakfast
                  easy-impressive
                  under-20-minutes
                  vegetarian-comfort-food
                  gluten-free]

collections.each do |collection|
  collection_url = base_url + '/recipes/collection/' + collection
  collection_doc = Nokogiri::HTML(open(collection_url).read)
  recipe_urls = []
  collection_doc.search('.teaser-item__title a').each do |a|
    recipe_url = a['href']
    full_recipe_url = base_url + recipe_url.strip.downcase
    recipe_doc = Nokogiri::HTML(open(chosen_recipe_url).read)
    recipe = Recipe.create(title: a.inner_text,
                        img_url: recipe_doc.search('.recipe-header img').first['src'],
                        description: recipe_doc.search('.recipe-header__description').first.inner_text.strip,
                        prep_time: '',
                        cook_time: '',
                        serves: '',
                        difficulty: '',
                        ingredients_count: '',
                        category: collection,
                        video_url: '')
    recipe_doc.search('.ingredients-list__item').each do |ingredient|
      Ingredient.create(recipe: recipe,
                        description: ingredient.inner_text)
    end
    recipe_doc.search('.method__item').each_with_index do |method, i|
      step.create(recipe: recipe,
                  number: (i + 1),
                  description: method.inner_text)
    end
  end
end


# recipe_doc.search('.nutrition li').each do |li|
#   nutrition_item = []
#   li.search('span').each { |span| nutrition_item << span.inner_text }
#   nutritions << nutrition_item
# end
