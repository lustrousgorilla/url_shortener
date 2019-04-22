# frozen_string_literal: true

# == Schema Information
#
# Table name: visits
#
#  id            :bigint(8)        not null, primary key
#  short_link_id :bigint(8)        not null
#  referrer      :string           not null
#  user_agent    :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryBot.define do
  factory :visit do
    short_link
    referrer { Faker::Internet.url }
    user_agent { Faker::Internet.user_agent }
  end
end
