# frozen_string_literal: true

require_relative "../lib/personality_diagnosis/calculator"

RSpec.describe PersonalityDiagnosis::Calculator do
  let(:calculator) { described_class.new }

  describe "#call" do
    let(:answers) do
      PersonalityDiagnosis::Questions.all.each_with_object({}) do |question, acc|
        acc[question[:id]] = question[:options].first[:value]
      end
    end

    it "returns persona summary and breakdown" do
      result = calculator.call(answers)

      expect(result[:summary][:persona]).not_to be_nil
      expect(result[:breakdown]).to be_a(Hash)
      expect(result[:meta][:answered]).to eq(PersonalityDiagnosis::Questions.ids.size)
    end

    it "raises error when question id is unknown" do
      expect do
        calculator.call("unknown" => "value")
      end.to raise_error(ArgumentError)
    end
  end
end

