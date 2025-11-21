export type Trait = "clarity" | "creativity" | "empathy" | "resilience";

export interface AnswerMap {
  [questionId: string]: string;
}

export interface QuestionOption {
  value: string;
  label: string;
  hint?: string;
}

export interface Question {
  id: string;
  dimension: string;
  text: string;
  options: QuestionOption[];
}

export interface DiagnosisResponse {
  summary: {
    persona: string;
    headline: string;
    description: string;
  };
  breakdown: Record<
    Trait,
    {
      raw: number;
      ratio: number;
    }
  >;
  meta: {
    dominant_trait: Trait;
    dominant_score: number;
    total_questions: number;
    answered: number;
  };
  suggestions: string[];
}

