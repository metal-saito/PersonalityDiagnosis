# Backend (Ruby / Sinatra)

## セットアップ

```bash
cd backend
cp env.example .env   # 必要に応じて CLIENT_ORIGIN を変更
bundle install
```

## 開発サーバー

```bash
bundle exec rerun "bundle exec rackup -s puma -p 4567"
```

`.env` で指定した `CLIENT_ORIGIN` が CORS の許可オリジンになります（未設定の場合は `*`）。

## エンドポイント

| Method | Path             | 説明                             |
| ------ | ---------------- | -------------------------------- |
| GET    | `/health`        | 生存監視                         |
| GET    | `/api/questions` | 診断に使用する設問リストを取得   |
| POST   | `/api/diagnose`  | 回答 `{ answers: { question_id: option } }` を解析 |

## テスト

```bash
bundle exec rspec
```

