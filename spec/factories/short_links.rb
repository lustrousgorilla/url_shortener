# frozen_string_literal: true

# == Schema Information
#
# Table name: short_links
#
#  id         :bigint(8)        not null, primary key
#  long_url   :string           not null
#  short_url  :string           not null
#  user_id    :bigint(8)        not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#


FactoryBot.define do
  factory :short_link do
    long_url { Faker::Internet.unique.url }
    sequence(:user_id) { |i| i }
  end
end
