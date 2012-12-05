Capybara.add_selector(:link) do
  xpath {|rel| ".//a[@rel='#{rel}']"}
end

RSpec.configure do |c|
  c.alias_it_should_behave_like_to :it_has_behavior, 'has behavior:'
end