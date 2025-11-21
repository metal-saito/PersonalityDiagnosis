# frozen_string_literal: true

module PersonalityDiagnosis
  module Questions
    module_function

    TRAITS = %i[clarity creativity empathy resilience].freeze

    QUESTION_SET = [
      {
        id: "focus",
        dimension: "フォーカス",
        text: "新しいタスクを始めるとき、どのように進めますか？",
        options: [
          {
            value: "structure",
            label: "ゴールから逆算して計画を立てる",
            hint: "段取り重視",
            weights: { clarity: 3, resilience: 1 }
          },
          {
            value: "experiment",
            label: "まずは試しに動きながら調整する",
            hint: "柔軟性重視",
            weights: { creativity: 2, resilience: 1 }
          },
          {
            value: "collaborate",
            label: "周りに意見を聞きながら決めていく",
            hint: "協調性重視",
            weights: { empathy: 3 }
          }
        ]
      },
      {
        id: "stress",
        dimension: "ストレス反応",
        text: "プレッシャーが高い状況で最も頼りにするものは？",
        options: [
          {
            value: "data",
            label: "データや根拠を再確認する",
            hint: "論理的な裏付け",
            weights: { clarity: 2, resilience: 1 }
          },
          {
            value: "people",
            label: "仲間と状況を共有して支え合う",
            hint: "チームワーク",
            weights: { empathy: 2, resilience: 1 }
          },
          {
            value: "momentum",
            label: "勢いを保つために新しい工夫をする",
            hint: "クリエイティブ対処",
            weights: { creativity: 3 }
          }
        ]
      },
      {
        id: "learning",
        dimension: "学習スタイル",
        text: "新しいスキルを身につけるときのアプローチは？",
        options: [
          {
            value: "frameworks",
            label: "体系化された教材を順番にマスターする",
            hint: "構造化学習",
            weights: { clarity: 3 }
          },
          {
            value: "projects",
            label: "小さなプロジェクトで試しながら覚える",
            hint: "実験型学習",
            weights: { creativity: 2, resilience: 1 }
          },
          {
            value: "peers",
            label: "コミュニティで対話しながら吸収する",
            hint: "対話型学習",
            weights: { empathy: 2 }
          }
        ]
      },
      {
        id: "feedback",
        dimension: "フィードバック",
        text: "フィードバックを受けるときのスタンスは？",
        options: [
          {
            value: "metrics",
            label: "測定指標とのズレを知りたい",
            hint: "定量的視点",
            weights: { clarity: 2 }
          },
          {
            value: "nuance",
            label: "背景や感情面も丁寧に聞きたい",
            hint: "ニュアンス重視",
            weights: { empathy: 2 }
          },
          {
            value: "future",
            label: "次に試すアイデアを一緒に考えたい",
            hint: "未来志向",
            weights: { creativity: 2, resilience: 1 }
          }
        ]
      },
      {
        id: "momentum",
        dimension: "推進力",
        text: "長期プロジェクトでモチベーションを保つコツは？",
        options: [
          {
            value: "ritual",
            label: "進捗を可視化し小さな達成を祝う",
            hint: "ルーティン管理",
            weights: { clarity: 1, resilience: 2 }
          },
          {
            value: "story",
            label: "プロジェクトの意義を言語化し続ける",
            hint: "ストーリーテリング",
            weights: { empathy: 1, creativity: 1 }
          },
          {
            value: "variety",
            label: "時々やり方を変えて刺激を入れる",
            hint: "変化の導入",
            weights: { creativity: 2 }
          }
        ]
      }
    ].freeze

    def all
      QUESTION_SET
    end

    def ids
      QUESTION_SET.map { |q| q[:id] }
    end

    def public_view
      QUESTION_SET.map do |question|
        {
          id: question[:id],
          dimension: question[:dimension],
          text: question[:text],
          options: question[:options].map do |option|
            {
              value: option[:value],
              label: option[:label],
              hint: option[:hint]
            }
          end
        }
      end
    end
  end
end

