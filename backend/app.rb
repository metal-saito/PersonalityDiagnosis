# frozen_string_literal: true

require "dotenv/load"
require "json"
require "sinatra/base"
require "sinatra/json"

require_relative "lib/personality_diagnosis/questions"
require_relative "lib/personality_diagnosis/calculator"

module PersonalityDiagnosis
  class App < Sinatra::Base
    helpers Sinatra::JSON

    configure do
      set :allow_origin, ENV.fetch("CLIENT_ORIGIN", "*")
      set :allow_methods, %w[GET POST OPTIONS]
      set :allow_headers, ["content-type"]
      set :allow_credentials, true
      set :max_age, 86_400
    end

    before do
      content_type :json
      response.headers["Access-Control-Allow-Origin"] = settings.allow_origin
      response.headers["Access-Control-Allow-Credentials"] = settings.allow_credentials.to_s
    end

    options "*" do
      response.headers["Allow"] = "GET,POST,OPTIONS"
      response.headers["Access-Control-Allow-Origin"] = settings.allow_origin
      response.headers["Access-Control-Allow-Headers"] = settings.allow_headers.join(",")
      response.headers["Access-Control-Allow-Methods"] = settings.allow_methods.join(",")
      response.headers["Access-Control-Max-Age"] = settings.max_age.to_s
      200
    end

    get "/health" do
      json(status: "ok", timestamp: Time.now.utc)
    end

    get "/api/questions" do
      json(questions: PersonalityDiagnosis::Questions.public_view)
    end

    post "/api/diagnose" do
      payload = parse_payload
      answers = payload["answers"]

      halt 422, json(error: "answers must be provided as an object") unless answers.is_a?(Hash)

      answers = stringify_keys(answers)
      expected_ids = PersonalityDiagnosis::Questions.ids
      missing = expected_ids - answers.keys

      unless missing.empty?
        halt 422, json(error: "missing_answers", details: { missing: missing })
      end

      if answers.values.any? { |value| value.to_s.strip.empty? }
        halt 422, json(error: "all_answers_required")
      end

      calculator = PersonalityDiagnosis::Calculator.new
      result = calculator.call(answers)

      json(result)
    rescue PersonalityDiagnosis::Calculator::InsufficientAnswersError => e
      halt 422, json(error: "insufficient_answers", message: e.message)
    end

    error do
      e = env["sinatra.error"]
      status 500
      json(error: "internal_server_error", message: e.message)
    end

    private

    def parse_payload
      request.body.rewind
      body = request.body.read
      return {} if body.to_s.strip.empty?

      JSON.parse(body)
    rescue JSON::ParserError
      halt 400, json(error: "invalid_json")
    end

    def stringify_keys(hash)
      hash.each_with_object({}) do |(key, value), acc|
        acc[key.to_s] = value
      end
    end
  end
end

