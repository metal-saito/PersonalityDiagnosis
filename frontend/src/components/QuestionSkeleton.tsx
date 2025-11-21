export function QuestionSkeleton() {
  return (
    <div className="question-card skeleton">
      <div className="skeleton-line short" />
      <div className="skeleton-line" />
      <div className="skeleton-options">
        {[0, 1, 2].map((item) => (
          <div className="skeleton-option" key={item}>
            <div className="skeleton-bullet" />
            <div className="skeleton-line" />
          </div>
        ))}
      </div>
    </div>
  );
}

