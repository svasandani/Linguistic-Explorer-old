Factory.define :group do |f|
  f.name           "The Best Group"
  f.privacy        Group::PUBLIC
  f.depth_maximum  Group::MAXIMUM_ASSIGNABLE_DEPTH
  f.example_fields "gloss, number"
end

Factory.define :user do |f|
  f.name          "Bob Jones"
  f.email         "bob@example.com"
  f.access_level  "user"
  f.password      "password"
end

Factory.define :ling do |f|
  f.name "English"
  f.depth 0
  f.association :group, :factory => :group
end

Factory.define :membership do |f|
  f.level "member"
  f.association :group, :factory => :group
  f.association :member, :factory => :user
end

Factory.define :property do |f|
  f.name "Adjective"
# NOTE: You must pass the following two yourself because the category must belong to the same group as the created property
#  f.association :category, :factory => :category
#  f.association :group, :factory => :group
end

Factory.define :category do |f|
  f.name "Grammar"
  f.depth 0
  f.association :group, :factory => :group
end

Factory.define :lings_property do |f|
end

Factory.define :example do |f|
  f.name "SampleExample"
# NOTE: You must pass the following two yourself because the ling must belong to the same group as the created example
#  f.association :group, :factory => :group
#  f.association :ling, :factory => :ling
end

Factory.define :examples_lings_property do |f|
end

Factory.define :search do |f|
  f.name "New Search"
  f.association :group, :factory => :group
  f.association :creator, :factory => :user
end

Factory.define :stored_value do |f|
end
