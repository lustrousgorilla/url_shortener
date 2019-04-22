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

require "rails_helper"

RSpec.describe Visit, type: :model do
  let(:visit) { build(:visit) }

  it "has a valid factory" do
    expect(visit).to be_valid
  end

  context "db" do
    context "columns" do
      it { should have_db_column(:short_link_id).of_type(:integer).with_options(null: false) }
      it { should have_db_column(:referrer).of_type(:string).with_options(null: false) }
      it { should have_db_column(:user_agent).of_type(:string).with_options(null: false) }
      it { should have_db_column(:user_agent).of_type(:string).with_options(null: false) }
      it { should have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    end

    context "indices" do
      it { should have_db_index(:short_link_id) }
    end

    context "constraints" do
      it "cascades deletion of associated short_link" do
        short_link = create(:short_link, visit_count: 3)
        expect(Visit.count).to eq(3)
        short_link.destroy
        expect(Visit.count).to eq(0)
      end
    end
  end

  context "associations" do
    it { should belong_to(:short_link) }
  end

  context "validations" do
    # subject { create(:visit) }
    # it { should validate_presence_of(:referrer) }
    # it { should validate_presence_of(:user_agent) }
  end

  context "callbacks" do
    describe "#set_nil_attributes" do
      it "sets nil referrer to 'none'" do
        visit.referrer = nil
        visit.save
        expect(visit.referrer).to eq("none")
      end

      it "sets nil user_agent to 'unknown'" do
        visit.user_agent = nil
        visit.save
        expect(visit.user_agent).to eq("unknown")
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
