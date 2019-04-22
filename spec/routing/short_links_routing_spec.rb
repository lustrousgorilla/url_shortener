# frozen_string_literal: true

require "rails_helper"

RSpec.describe ShortLinksController, type: :routing do
  describe "routing" do
    it "routes to #create" do
      expect(post: "/short_link").to route_to("short_links#create")
    end

    it "routes to #redirect" do
      short_link = "4HPQ7ikE1"
      expect(get: "/#{short_link}").to route_to("short_links#redirect", short_link: short_link)
    end

    it "routes to #analytics" do
      short_link = "4HPQ7ikE1"
      expect(get: "/#{short_link}+").to route_to("short_links#analytics", short_link: "#{short_link}+")
    end
  end
end
