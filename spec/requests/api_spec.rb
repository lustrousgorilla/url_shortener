# frozen_string_literal: true

require "rails_helper"
require "airborne"

RSpec.describe "API", type: :request do
  describe "POST /short_link" do
    subject(:api_request) do
      post "/short_link", params: { long_url: long_url, user_id: user_id }, as: :json
    end

    let(:long_url) { Faker::Internet.unique.url }
    let(:user_id) { 1 }

    describe "with new long_url" do
      it "creates a short link" do
        expect { api_request }.to change { ShortLink.count }.by(1)
      end

      it "responds with the new short link" do
        api_request
        expect_status(:created)
        short_link = ShortLink.last
        expect(short_link.long_url).to eq(long_url)
        expect_json(long_url: long_url, short_link: short_link.short_url)
      end
    end

    describe "with existing long_url for new user" do
      it "creates a different short link" do
        existing_short_link = create(:short_link, long_url: long_url, user_id: user_id + 1)
        expect { api_request }.to change { ShortLink.count }.by(1)
        new_short_link = ShortLink.last
        expect(new_short_link.short_url).not_to eq(existing_short_link.short_url)
      end

      it "responds with the new short link" do
        create(:short_link, long_url: long_url, user_id: user_id + 1)
        api_request
        expect_status(:created)
        short_link = ShortLink.last
        expect(short_link.long_url).to eq(long_url)
        expect_json(long_url: long_url, short_link: short_link.short_url)
      end
    end

    describe "with existing long_url for same user" do
      it "does not create a short link" do
        create(:short_link, long_url: long_url, user_id: user_id)
        expect { api_request }.not_to (change { ShortLink.count })
      end

      it "responds with the existing short link" do
        short_link = create(:short_link, long_url: long_url, user_id: user_id)
        api_request
        expect_status(:ok)
        expect_json(long_url: short_link.long_url, short_link: short_link.short_url)
      end
    end

    describe "with invalid params" do
      let(:user_id) { nil }

      it "responds with errors" do
        api_request
        expect_status(:unprocessable_entity)
        expect_json(status: 422, errors: { user_id: ["can't be blank"] })
      end
    end
  end

  describe "GET /:short_link" do
    before(:all) do
      @referrer = Faker::Internet.url
      @user_agent = Faker::Internet.user_agent
    end

    describe "format HTML" do
      subject(:browser_request) do
        get "/#{short_url}", headers: { "HTTP_REFERER" => @referrer, "HTTP_USER_AGENT" => @user_agent }
      end

      let!(:short_link) { create(:short_link) }

      describe "for known short link" do
        let(:short_url) { short_link.short_url }

        it "creates a visit with request metadata" do
          expect { browser_request }.to change { short_link.reload.visits_count }.by(1)
          visit = short_link.visits.last
          expect(visit.referrer).to eq(@referrer)
          expect(visit.user_agent).to eq(@user_agent)
        end

        it "redirects to long_url" do
          expect(browser_request).to redirect_to(short_link.long_url)
        end
      end

      describe "for unknown short link" do
        let(:short_url) { "allyourbasearebelongtous" }

        it "responds not found" do
          browser_request
          expect_status(:not_found)
        end
      end
    end

    describe "format JSON" do
      subject(:api_request) do
        get "/#{short_url}", as: :json
      end

      let!(:short_link) { create(:short_link) }

      describe "for known short link" do
        let(:short_url) { short_link.short_url }

        it "creates a visit with request metadata" do
          expect { api_request }.to change { short_link.reload.visits_count }.by(1)
          visit = short_link.visits.last
          expect(visit.referrer).to eq("none")
          expect(visit.user_agent).to eq("unknown")
        end

        it "responds with long_url" do
          api_request
          expect_status(:moved_permanently)
          expect_json(status: 301, location: short_link.long_url)
        end
      end

      describe "for unknown short link" do
        let(:short_url) { "allyourbasearebelongtous" }

        it "responds not found" do
          api_request
          expect_status(:not_found)
          expect_json(status: 404, error: "unknown short link")
        end
      end
    end
  end

  describe "GET /:short_link+ (analytics view)" do
    subject(:api_request) do
      get "/#{short_url}+", as: :json
    end

    let!(:short_link) { create(:short_link, visit_count: 3) }

    describe "for known short link" do
      let(:short_url) { short_link.short_url }

      it "responds with short link analytics" do
        api_request
        expect_status(:ok)
        visits_json = short_link.visits.map do |v|
          { time: v.created_at.iso8601, referrer: v.referrer, user_agent: v.user_agent }
        end
        expect_json(response: visits_json)
      end
    end

    describe "for unknown short link" do
      let(:short_url) { "allyourbasearebelongtous" }

      it "responds not found" do
        api_request
        expect_status(:not_found)
        expect_json(status: 404, error: "unknown short link")
      end
    end
  end
end
