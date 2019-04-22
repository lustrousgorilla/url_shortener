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


require "rails_helper"

RSpec.describe ShortLink, type: :model do
  let(:short_link) { build(:short_link) }

  it "has a valid factory" do
    expect(short_link).to be_valid
  end

  context "db" do
    context "columns" do
      it { should have_db_column(:long_url).of_type(:string).with_options(null: false) }
      it { should have_db_column(:short_url).of_type(:string).with_options(null: false) }
      it { should have_db_column(:user_id).of_type(:integer).with_options(null: false) }
    end

    context "indices" do
      it { should have_db_index(:short_url).unique(true) }
      it { should have_db_index(%i[user_id long_url]).unique(true) }
    end
  end

  context "associations"

  context "validations" do
    subject { create(:short_link) }
    it { should validate_presence_of(:long_url) }
    it { should validate_presence_of(:user_id) }
    it { should validate_uniqueness_of(:long_url).scoped_to(:user_id).case_insensitive }
  end

  context "callbacks" do
    describe "#normalize_url" do
      it "downcases provided long_url" do
        short_link.long_url = "http://GOOgle.CoM"
        short_link.save
        expect(short_link.long_url).to eq("http://google.com")
      end
    end

    describe "#generate_short_url" do
      it "generates an 8 character short_url" do
        expect(short_link.short_url).to be_nil
        short_link.save
        expect(short_link.short_url&.length).to eq(8)
      end
    end
  end

  describe "scopes"

  describe "public instance methods" do
    context "responds to its methods"
    context "executes methods correctly" do
      context "#method_name" do
        describe "does something..."
      end
    end
  end

  describe "public class methods" do
    context "responds to its methods"
    context "executes methods correctly" do
      context "self.method_name" do
        describe "does something..."
      end
    end
  end
end
