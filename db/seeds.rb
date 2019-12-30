puts "Deleting records"
Ingredient.destroy_all
Step.destroy_all
Recipe.destroy_all
UserCategory.destroy_all
UserPreference.destroy_all
User.destroy_all
Category.destroy_all

base_url = 'https://www.bbcgoodfood.com'

# Add new good food collections below to widen the database (each collection creates a new category)
collections = %w[ batch-cooking
                  healthy-breakfast
                  easy-impressive
                  under-20-minutes
                  vegetarian-comfort-food
                  pasta
                  soup
                  casserole
                  healthy-lunch
                  family-meal
                  vegetarian-party
                  stir-fry
                  tapas
                  gluten-free]
collections.each { |collection| Category.create(name: collection) }

puts "Creating users with random categories and preferences"
name_arr = %w[rob emma joe ben tilly ollie]
name_arr.each do |name|
  user = User.create(email: "#{name}@swipechef.com", password: '123456')
  Category.all.shuffle.sample(rand(0..5)).each do |category|
    UserCategory.create(user: user, category: category)
  end
  UserPreference.create(user: user,
                        max_cooking_time: (rand(1..12) * 10), # Between 10 mins and 2 hrs
                        cook_for_min: rand(1..3),
                        cook_for_max: rand(4..10))
end

collections.each_with_index do |collection, i|
  puts "Creating recipes in collection #{i + 1} of #{collections.length}"
  collection_url = base_url + '/recipes/collection/' + collection + '/?IGNORE_GEO_REDIRECT_GLOBAL=true' # Temporary
  collection_doc = Nokogiri::HTML(open(collection_url, allow_redirections: :all).read) # Temporary
  collection_doc.search('.teaser-item__title a').each do |a|
    recipe_path = a['href'].strip.downcase
    recipe_url = base_url + recipe_path + '?IGNORE_GEO_REDIRECT_GLOBAL=true' # Temporary
    recipe_doc = Nokogiri::HTML(open(recipe_url, allow_redirections: :all).read) # Temporary

    # Finding img_url and removing itoken suffix
    img_token_regex = /(?<itok>\?.*$)/
    img_url = recipe_doc.search('.recipe-header img').first['src'][2..-1] # Removing // prefix
    img_url = img_url[0...(img_url.length - img_url.match(img_token_regex)["itok"].length)]

    # Contains in§o on prep/cook times, serving no. and difficulty
    raw_details = recipe_doc.search('.recipe-details__text')
    times_string = raw_details[0].inner_text # Cook and prep times

    # Regex used to isolate serving number from details
    serving_regex = /^(\s|[a-zA-Z])*(?<number>\d*)/

    # Regex used to isolate prep/cook time section from times_string
    prep_time_isolation_regex = /Prep:\s*(?<prep_times>\d*\s*(mins|hrs?)((\s|,)*\d*\s*(mins|hrs?))?)/
    cook_time_isolation_regex = /Cook:\s*(?<cook_times>\d*\s*(mins|hrs?)((\s|,)*\d*\s*(mins|hrs?))?)/

    # Capture groups used to assign matches to variables. Regex is only administered is there are matches to avoid errors
    prep_times_isolated = times_string.match(prep_time_isolation_regex)["prep_times"] if prep_time_isolation_regex.match?(times_string)
    cook_times_isolated = times_string.match(cook_time_isolation_regex)["cook_times"] if cook_time_isolation_regex.match?(times_string)

    # Regex used to isolate time described in terms of hours/minutes from the above prep/cook time strings
    time_hours_regex = /((?<hrs>\d*)\s*hrs?)/
    time_mins_regex = /((?<mins>\d*)\s*mins?)/

    # To avoid errors, above regex is only applied if there are any matches. Time set to 0 default
    prep_time_hrs = (time_hours_regex.match?(prep_times_isolated) ? prep_times_isolated.match(time_hours_regex)["hrs"].to_i : 0 )
    prep_time_mins = (time_mins_regex.match?(prep_times_isolated) ? prep_times_isolated.match(time_mins_regex)["mins"].to_i : 0 )
    cook_time_hrs = (time_hours_regex.match?(cook_times_isolated) ? cook_times_isolated.match(time_hours_regex)["hrs"].to_i : 0 )
    cook_time_mins = (time_mins_regex.match?(cook_times_isolated) ? cook_times_isolated.match(time_mins_regex)["mins"].to_i : 0 )

    recipe = Recipe.create( title: a.inner_text.strip,
                            img_url: img_url,
                            description: recipe_doc.search('.recipe-header__description').first.inner_text.strip,
                            prep_time: (prep_time_mins + (prep_time_hrs * 60)),
                            cook_time: (cook_time_mins + (cook_time_hrs * 60)),
                            serves: raw_details[2].inner_text.match(serving_regex)["number"],
                            difficulty: raw_details[1].inner_text.strip,
                            category: collection,
                            video_url: '')

    # Creating ingredient from each ingredient HTML element
    recipe_doc.search('.ingredients-list__item').each do |ingredient_li|
      ingredient_text = ingredient_li.inner_text

      # Using regex to remove tooltip text from ingredient description (if tooltip exists)
      if ingredient_li.children.children.children.any?
        tooltip_regex = /#{Regexp.quote(ingredient_li.children.children.children.inner_text)}/
        ingredient_text.gsub!(tooltip_regex, '')
      end
      Ingredient.create(recipe: recipe,
                        description: ingredient_text.strip)
    end
    recipe_doc.search('.method__item').each_with_index do |method, i|
      Step.create(recipe: recipe,
                  number: (i + 1),
                  description: method.inner_text)
    end
    recipe.update(ingredients_count: recipe_doc.search('.ingredients-list__item').count)
  end
end

# Nutrition details available, scrape method below
# recipe_doc.search('.nutrition li').each do |li|
#   nutrition_item = []
#   li.search('span').each { |span| nutrition_item << span.inner_text }
#   nutritions << nutrition_item
# end
