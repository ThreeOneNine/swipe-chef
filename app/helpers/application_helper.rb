module ApplicationHelper
def clean_category_name(name)
	name.split("-").map(&:capitalize).join(" ")
end
end
