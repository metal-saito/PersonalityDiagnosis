# frozen_string_literal: true

require "json"
require "rack/test"
require_relative "../app"

RSpec.describe PersonalityDiagnosis::App do
  include Rack::Test::Methods

  def app
    described_class
  end

  describe "GET /api/questions" do
    it "returns the question set" do
      get "/api/questions"

      expect(last_response.status).to eq(200)
      payload = JSON.parse(last_response.body)
      expect(payload["questions"].size).to eq(PersonalityDiagnosis::Questions.ids.size)
    end
  end

  describe "POST /api/diagnose" do
    let(:answers) do
      PersonalityDiagnosis::Questions.all.each_with_object({}) do |question, acc|
        acc[question[:id]] = question[:options].first[:value]
      end
    end

    it "returns a diagnosis" do
      post "/api/diagnose", JSON.generate({ answers: answers }), { "CONTENT_TYPE" => "application/json" }

      expect(last_response.status).to eq(200)
      payload = JSON.parse(last_response.body)
      expect(payload["summary"]).to include("persona")
    end

    it "fails when answers are missing" do
      post "/api/diagnose", JSON.generate({ answers: {} }), { "CONTENT_TYPE" => "application/json" }

      expect(last_response.status).to eq(422)
    end
  end
end

