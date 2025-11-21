import type { AnswerMap, DiagnosisResponse, Question } from "../types";

const DEFAULT_BASE_URL = "http://localhost:4567";

const apiBaseUrl = (() => {
  const url = import.meta.env.VITE_API_BASE_URL ?? DEFAULT_BASE_URL;
  return url.replace(/\/$/, "");
})();

async function handleResponse<T>(response: Response): Promise<T> {
  if (!response.ok) {
    const text = await response.text();
    throw new Error(text || response.statusText);
  }
  return response.json() as Promise<T>;
}

export async function fetchQuestions(signal?: AbortSignal): Promise<Question[]> {
  const response = await fetch(`${apiBaseUrl}/api/questions`, { signal });
  const payload = await handleResponse<{ questions: Question[] }>(response);
  return payload.questions;
}

export async function requestDiagnosis(answers: AnswerMap): Promise<DiagnosisResponse> {
  const response = await fetch(`${apiBaseUrl}/api/diagnose`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify({ answers })
  });

  return handleResponse<DiagnosisResponse>(response);
}

