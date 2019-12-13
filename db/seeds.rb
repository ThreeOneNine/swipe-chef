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
  recipes = []
  collection_doc.search('.teaser-item__title a').each do |a|
    recipes << [a.inner_text, a['href']]
  end

  recipes.each { |recipe_array| puts recipe_array[0] }
  puts ''
  puts 'Please select a recipe'
  chosen_recipe = gets.chomp
  until recipes.any? { |recipe| recipe[0].strip.downcase == chosen_recipe.strip.downcase }
    puts ''
    puts 'Invalid selection, please select a recipe'
    chosen_recipe = gets.chomp
  end
  puts ''
  recipe_add_url = (recipes.select { |recipe_arr| recipe_arr[0].strip.downcase == chosen_recipe.strip.downcase }).first[1]

  chosen_recipe_url = base_url + recipe_add_url
  # chosen_recipe_url = "https://www.bbcgoodfood.com//recipes/quick-cottage-pie"
  recipe_doc = Nokogiri::HTML(open(chosen_recipe_url).read)

  methods = []
  recipe_doc.search('.method__item').each { |method| methods << method.inner_text }
  ingredients = []
  recipe_doc.search('.ingredients-list__item').each { |ingredient| ingredients << ingredient.inner_text }
  nutritions = []
  recipe_doc.search('.nutrition li').each do |li|
    nutrition_item = []
    li.search('span').each { |span| nutrition_item << span.inner_text }
    nutritions << nutrition_item
  end

  details = []
  recipe_doc.search('.recipe-details__text').each { |detail| details << detail.inner_text.strip }

  image_url = recipe_doc.search('.recipe-header img').first['src']

  puts image_url
  puts ''
  puts ''
  puts 'DETAILS'
  details.each { |detail| puts detail }
  puts ''
  puts ''
  puts 'INGREDIENTS'
  ingredients.each_with_index { |ingredient, i| puts "#{i + 1}. #{ingredient}" }
  puts ''
  puts ''
  puts 'METHOD'
  methods.each_with_index { |method, i| puts "#{i + 1}. #{method}" }
  puts ''
  puts ''
  puts 'NUTRITION'
  nutritions.each { |nutrition| puts "#{nutrition[0]} - #{nutrition[1]}" }
end

