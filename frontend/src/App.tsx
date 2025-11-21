import { useEffect, useMemo, useState } from "react";
import { fetchQuestions, requestDiagnosis } from "./api/client";
import type { AnswerMap, DiagnosisResponse, Question } from "./types";
import { QuestionCard } from "./components/QuestionCard";
import { QuestionSkeleton } from "./components/QuestionSkeleton";
import { ResultPanel } from "./components/ResultPanel";

function useQuestionnaire() {
  const [questions, setQuestions] = useState<Question[]>([]);
  const [answers, setAnswers] = useState<AnswerMap>({});
  const [error, setError] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const controller = new AbortController();
    fetchQuestions(controller.signal)
      .then((data) => {
        setQuestions(data);
        setAnswers(
          data.reduce<AnswerMap>((acc, question) => {
            acc[question.id] = "";
            return acc;
          }, {})
        );
        setIsLoading(false);
      })
      .catch((err) => {
        if (err.name === "AbortError") {
          return;
        }
        setError("設問の取得に失敗しました。サーバーを確認してください。");
        setIsLoading(false);
      });

    return () => controller.abort();
  }, []);

  const setAnswer = (questionId: string, value: string) => {
    setAnswers((prev) => ({ ...prev, [questionId]: value }));
  };

  const answeredCount = useMemo(
    () => Object.values(answers).filter((value) => value).length,
    [answers]
  );

  const readyToSubmit = useMemo(
    () => questions.length > 0 && answeredCount === questions.length,
    [answeredCount, questions.length]
  );

  return {
    questions,
    answers,
    setAnswer,
    error,
    setError,
    readyToSubmit,
    answeredCount,
    questionCount: questions.length,
    isLoading
  };
}

export default function App() {
  const [diagnosis, setDiagnosis] = useState<DiagnosisResponse | null>(null);
  const [loading, setLoading] = useState(false);
  const {
    questions,
    answers,
    setAnswer,
    error,
    setError,
    readyToSubmit,
    answeredCount,
    questionCount,
    isLoading
  } = useQuestionnaire();

  const completionRate = questionCount > 0 ? Math.round((answeredCount / questionCount) * 100) : 0;
  const nextQuestion = questions.find((question) => !answers[question.id]);
  const hasResult = Boolean(diagnosis);

  const handleSubmit = async () => {
    try {
      setLoading(true);
      setError(null);
      const result = await requestDiagnosis(answers);
      setDiagnosis(result);
    } catch (err) {
      setError(err instanceof Error ? err.message : "診断に失敗しました");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="app-shell">
      <header className="heading">
        <span className="question-meta">Personality Diagnosis</span>
        <h1>チーム力を引き出すセルフ診断</h1>
        <p>5つの質問に答えると、いま発揮しやすいリーダーシップタイプを可視化します。</p>
      </header>

      <main className="card">
        <section className="insight-row">
          <div className="insight-card">
            <div className="insight-label">回答状況</div>
            <p className="insight-value">
              {answeredCount}/{questionCount || "–"}
            </p>
            <div className="progress-track">
              <div className="progress-thumb" style={{ width: `${completionRate}%` }} />
            </div>
            <small>完了度 {completionRate}%</small>
          </div>
          <div className="insight-card accent">
            <div className="insight-label">次のテーマ</div>
            <p className="insight-value">{nextQuestion ? nextQuestion.dimension : "すべて回答済み"}</p>
            <small>{nextQuestion ? nextQuestion.text : "診断結果を確認しましょう"}</small>
          </div>
          <div className="insight-card">
            <div className="insight-label">診断ステータス</div>
            <p className="insight-value">{hasResult ? "最新の結果あり" : "未取得"}</p>
            <small>{hasResult ? "回答内容に応じて更新済み" : "回答後に自動表示されます"}</small>
          </div>
        </section>

        {isLoading ? (
          <div className="questions">
            {[0, 1, 2].map((item) => (
              <QuestionSkeleton key={item} />
            ))}
          </div>
        ) : (
          <div className="questions">
            {questions.map((question, index) => (
              <QuestionCard
                key={question.id}
                question={question}
                selected={answers[question.id]}
                order={index + 1}
                onChange={(value) => setAnswer(question.id, value)}
              />
            ))}
          </div>
        )}

        <div className="submit-area">
          <button
            type="button"
            className="submit-button"
            disabled={!readyToSubmit || loading}
            onClick={handleSubmit}
          >
            {loading ? "診断中..." : "診断する"}
          </button>
        </div>

        {error ? <div className="error-banner">{error}</div> : null}
        {diagnosis ? <ResultPanel data={diagnosis} /> : null}
      </main>
    </div>
  );
}

