# Personality Diagnosis

Ruby (Sinatra) ベースの API と TypeScript (React + Vite) フロントエンドで構成した性格診断ツールです。回答結果から 4 つの特性スコアを算出し、ペルソナと次のアクション候補を返します。

リポジトリ: [github.com/metal-saito/PersonalityDiagnosis](https://github.com/metal-saito/PersonalityDiagnosis)

## ディレクトリ構成

```
PersonalityDiagnosis/
├── backend/   # Ruby + Sinatra API
└── frontend/  # TypeScript + React クライアント
```

## クイックスタート

### バックエンド (Ruby / Sinatra)
```bash
cd backend
cp env.example .env            # CLIENT_ORIGIN を必要に応じて変更
bundle install
bundle exec rackup -s puma -p 4567
```

### フロントエンド (TypeScript / React)
```bash
cd frontend
cp env.example .env            # VITE_API_BASE_URL を必要に応じて変更
npm install
npm run dev                    # http://localhost:5173 で確認
```

## 推奨ワークフロー

```bash
cd PersonalityDiagnosis
git init
git remote add origin git@github.com:metal-saito/PersonalityDiagnosis.git
git add .
git commit -m "Initial personality diagnosis app"
git push -u origin main
```

## テスト

- Ruby: `bundle exec rspec`
- Frontend: `npm run build` (型チェック + ビルド)

## 環境変数

| 場所     | 変数              | 説明                              | 例                          |
| -------- | ----------------- | --------------------------------- | --------------------------- |
| backend  | `CLIENT_ORIGIN`   | 許可するフロントエンドのオリジン | `http://localhost:5173`     |
| frontend | `VITE_API_BASE_URL` | バックエンド API の URL         | `http://localhost:4567`     |

