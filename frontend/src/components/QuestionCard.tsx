import type { Question } from "../types";

type Props = {
  question: Question;
  selected?: string;
  onChange: (value: string) => void;
  order: number;
};

export function QuestionCard({ question, selected, onChange, order }: Props) {
  return (
    <section className="question-card">
      <div className="question-header">
        <span className="question-pill">Q{String(order).padStart(2, "0")}</span>
        <span className="question-meta">{question.dimension}</span>
      </div>
      <p className="question-text">{question.text}</p>

      <ul className="option-list">
        {question.options.map((option, index) => {
          const optionId = `${question.id}-${option.value}`;
          const checked = selected === option.value;
          const letter = String.fromCharCode(65 + index);

          return (
            <li
              key={option.value}
              className={`option-item${checked ? " selected" : ""}`}
              onClick={() => onChange(option.value)}
            >
              <input
                type="radio"
                id={optionId}
                name={question.id}
                value={option.value}
                checked={checked}
                onChange={(event) => onChange(event.target.value)}
              />

              <div className="option-body">
                <label htmlFor={optionId} className="option-title">
                  <span className="option-letter">{letter}</span>
                  <strong>{option.label}</strong>
                </label>
                {option.hint ? <span className="option-hint">{option.hint}</span> : null}
              </div>
            </li>
          );
        })}
      </ul>
    </section>
  );
}

