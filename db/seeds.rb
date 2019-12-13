require 'open-uri'

puts "Deleting records"
Ingredient.destroy_all
Step.destroy_all
Recipe.destroy_all
UserCategory.destroy_all
UserPreference.destroy_all
User.destroy_all

puts "Creating users"
User.create(email: "rob@swipechef.com", password: '123456')
User.create(email: "emma@swipechef.com", password: '123456')
User.create(email: "joe@swipechef.com", password: '123456')
User.create(email: "ben@swipechef.com", password: '123456')
User.create(email: "tilly@swipechef.com", password: '123456')
User.create(email: "ollie@swipechef.com", password: '123456')

base_url = 'https://www.bbcgoodfood.com'

# Add new collections below to widen the database
collections = %w[ batch-cooking
                  healthy-breakfast
                  easy-impressive
                  under-20-minutes
                  vegetarian-comfort-food
                  gluten-free]

collections.each_with_index do |collection, i|
  puts "Creating recipes in collection #{i + 1} of #{collections.length}"
  collection_url = base_url + '/recipes/collection/' + collection
  collection_doc = Nokogiri::HTML(open(collection_url).read)
  recipe_urls = []
  collection_doc.search('.teaser-item__title a').each do |a|
    recipe_url = a['href']
    full_recipe_url = base_url + recipe_url.strip.downcase
    recipe_doc = Nokogiri::HTML(open(full_recipe_url).read)
    raw_details = recipe_doc.search('.recipe-details__text')
    serving_regex = /^(\s|[a-zA-Z])*(?<number>\d*)/

    prep_time_regex = /Prep:\s*(?<prep_times>\d*\s*(mins|hrs?)((\s|,)*\d*\s*(mins|hrs?))?)/
    cook_time_regex = /Cook:\s*(?<cook_times>\d*\s*(mins|hrs?)((\s|,)*\d*\s*(mins|hrs?))?)/

    time_hours_regex = /((?<hrs>\d*)\s*hrs?)/
    time_mins_regex = /((?<mins>\d*)\s*mins?)/

    recipe = Recipe.create( title: a.inner_text.strip,
                            img_url: recipe_doc.search('.recipe-header img').first['src'][2..-1],
                            description: recipe_doc.search('.recipe-header__description').first.inner_text.strip,
                            # prep_time: prep_hours_in_mins + prep_mins,
                            # cook_time: cook_hours_in_mins + cook_mins,
                            serves: raw_details[2].inner_text.match(serving_regex)["number"],
                            difficulty: raw_details[1].inner_text.strip,
                            category: collection,
                            video_url: '')
    recipe_doc.search('.ingredients-list__item').each do |ingredient|
      Ingredient.create(recipe: recipe,
                        description: ingredient.inner_text)
    end
    recipe_doc.search('.method__item').each_with_index do |method, i|
      Step.create(recipe: recipe,
                  number: (i + 1),
                  description: method.inner_text)
    end
    recipe.update(ingredients_count: recipe_doc.search('.ingredients-list__item').count)
  end
end

# To do:
# Create user categories and preferences

# Nutrition scrape
# recipe_doc.search('.nutrition li').each do |li|
#   nutrition_item = []
#   li.search('span').each { |span| nutrition_item << span.inner_text }
#   nutritions << nutrition_item
# end
