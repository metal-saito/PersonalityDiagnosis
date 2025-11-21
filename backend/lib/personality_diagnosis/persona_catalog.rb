# frozen_string_literal: true

module PersonalityDiagnosis
  module PersonaCatalog
    module_function

    CATALOG = {
      clarity: {
        name: "Insight Navigator",
        headline: "構造化と洞察で流れを整える分析家タイプ",
        description: "複雑な状況でも全体像を捉えて道筋を描ける人です。データや原則を頼りにチームを安定させ、精度の高い意思決定を支えます。",
        suggestions: [
          "アイデア志向のメンバーとペアを組み、0→1と1→10の両輪を回す",
          "計画レビューを定期化し、チームの安心感を高める",
          "学習ログを残して意思決定の再現性を共有する"
        ]
      },
      creativity: {
        name: "Concept Sprinter",
        headline: "実験とストーリーで動かす発想家タイプ",
        description: "変化を恐れず、新しい視点を素早く試せる人です。課題をチャンスに変え、チームに前向きな勢いをもたらします。",
        suggestions: [
          "仮説キャンバスを使って実験の意図と学びを見える化する",
          "成果物のプロトタイプを早期に共有し、フィードバックを早めに得る",
          "休息を予定に組み込み、創造性の回復を意識する"
        ]
      },
      empathy: {
        name: "Team Resonator",
        headline: "関係性の共鳴で成果を伸ばす共感タイプ",
        description: "メンバーの感情や動機を丁寧にすくい取り、安心して挑戦できる場をつくれます。調整役としてプロジェクトの推進力を高めます。",
        suggestions: [
          "1on1で得た気づきを匿名化してチームの学びに変える",
          "意思決定プロセスを可視化し、納得感を醸成する",
          "共同作業のリズムを提案し、心理的安全性を守る"
        ]
      },
      resilience: {
        name: "Momentum Keeper",
        headline: "持続力と回復力でゴールに導く粘り強さタイプ",
        description: "困難な局面でも淡々と改善を積み重ね、プロジェクトを完遂できる人です。焦りを吸収し、確実な前進を維持します。",
        suggestions: [
          "進捗のスナップショットを共有し、小さな前進を言語化する",
          "緊急度と重要度でタスクを再編し、集中すべき領域を示す",
          "バッファを確保し、チーム全体の体力を管理する"
        ]
      }
    }.freeze

    def find(trait)
      CATALOG.fetch(trait) { default_persona(trait) }
    end

    def default_persona(trait)
      {
        name: "Balanced Explorer",
        headline: "状況に応じてスタイルを切り替えられる柔軟型",
        description: "#{trait} の傾向が高まりつつある過渡期です。複数の強みをバランスよく伸ばせます。",
        suggestions: [
          "自分の意思決定ログを残し、得意パターンを言語化する",
          "チームから見た強みをヒアリングし、役割設計に活かす"
        ]
      }
    end
  end
end

