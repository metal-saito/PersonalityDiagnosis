# Frontend (TypeScript / Vite / React)

## セットアップ

```bash
cd frontend
cp env.example .env   # VITE_API_BASE_URL を編集
npm install
```

## 開発サーバー

```bash
npm run dev
```

`VITE_API_BASE_URL` をバックエンドの URL に合わせて設定してください（デフォルトは `http://localhost:4567`）。

## ビルド

```bash
npm run build
npm run preview
```

