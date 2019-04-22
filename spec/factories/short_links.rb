# frozen_string_literal: true

# == Schema Information
#
# Table name: short_links
#
#  id           :bigint(8)        not null, primary key
#  long_url     :string           not null
#  short_url    :string           not null
#  user_id      :bigint(8)        not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  visits_count :integer          default(0), not null
#

FactoryBot.define do
  factory :short_link do
    long_url { Faker::Internet.unique.url }
    sequence(:user_id) { |i| i }

    transient do
      visit_count { 0 }
    end

    after(:build) do |short_link, evaluator|
      short_link.visits += create_list(:visit, evaluator.visit_count, short_link: short_link)
    end
  end
end
