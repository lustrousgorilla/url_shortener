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

class ShortLink < ApplicationRecord
  has_many :visits

  before_validation :normalize_url, if: :long_url?
  before_validation :generate_short_url, on: :create

  validates_presence_of :user_id, :short_url
  validates :long_url, presence: true, uniqueness: { scope: :user_id, case_sensitive: false },
            url: { public_suffix: true }

  def as_json(*)
    { "long_url" => long_url, "short_link" => short_url }
  end

  private

    def normalize_url
      if long_url_changed?
        self.long_url = "http://" + long_url unless URI.parse(long_url).scheme.present?
        self.long_url = long_url.downcase
      end
    end

    def generate_short_url
      self.short_url = loop do
        url = SecureRandom.alphanumeric(8)
        break url unless ShortLink.exists?(short_url: url)
      end
    end
end
