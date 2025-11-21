import type { DiagnosisResponse } from "../types";

type Props = {
  data: DiagnosisResponse;
};

export function ResultPanel({ data }: Props) {
  const entries = Object.entries(data.breakdown);

  return (
    <section className="result-panel">
      <p className="question-meta">診断結果</p>
      <h2>{data.summary.persona}</h2>
      <p className="headline">{data.summary.headline}</p>
      <p>{data.summary.description}</p>

      <div className="result-meta">
        <div>
          <span>優勢な特性</span>
          <strong>{data.meta.dominant_trait}</strong>
        </div>
        <div>
          <span>スコア</span>
          <strong>{data.meta.dominant_score}</strong>
        </div>
        <div>
          <span>回答数</span>
          <strong>
            {data.meta.answered}/{data.meta.total_questions}
          </strong>
        </div>
      </div>

      <div className="traits-grid">
        {entries.map(([trait, score]) => (
          <div key={trait} className="trait-card">
            <span>{trait}</span>
            <div className="trait-score">
              <strong>{score.raw}</strong>
              <small>{Math.round(score.ratio * 100)}%</small>
            </div>
            <div className="trait-meter">
              <div className="trait-meter-value" style={{ width: `${Math.round(score.ratio * 100)}%` }} />
            </div>
          </div>
        ))}
      </div>

      <div className="suggestions">
        <strong>次のアクション候補</strong>
        <ul>
          {data.suggestions.map((item) => (
            <li key={item}>{item}</li>
          ))}
        </ul>
      </div>
    </section>
  );
}

