# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Webula::Application.initialize!

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  error_class = "field_with_errors"
  if html_tag =~ /<(label)[^>]+style=/
    style_attribute = html_tag =~ /class=['"]/
    html_tag.insert(class_attribute + 7, "#{error_class}; ")
  elsif html_tag =~ /<(label)/
    first_whitespace = html_tag =~ /\s/
    html_tag[first_whitespace] = " class='#{error_class}' "
  end
  html_tag
end
