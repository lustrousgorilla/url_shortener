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

class Visit < ApplicationRecord
  belongs_to :short_link, counter_cache: true

  before_validation :set_nil_attributes
  validates_presence_of :referrer, :user_agent

  def as_json(*)
    # super(only: [:referrer, :user_agent]).merge("time" => created_at.iso8601)
    slice("referrer", "user_agent").merge("time" => created_at.iso8601) # trim milliseconds
  end

  private

    def set_nil_attributes
      self.referrer = "none" unless referrer.present?
      self.user_agent = "unknown" unless user_agent.present?
    end
end
