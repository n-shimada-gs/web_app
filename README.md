# web_app
# メモアプリ

**Webアプリケーション**プラクティス・**WebアプリからのDB利用**の提出物です。

## 使用技術

- ruby "4.0.6"
- Sinatra "4.2.0"
- puma "8.0.0"
- rackup "2.3.0"
- pg
- データ保存: PostgreSQLに保存(`pg`gemでSQLを実行)

## 動作環境

- Ruby（バージョンは `.ruby-version` を参照。rbenv でのバージョン管理を想定しています）
- Bundler

## セットアップ手順

### 1. リポジトリを取得する

**クローンの方法は、開発ブランチのみもしくはmainからクローンの二通りがあります。**

```bash
git clone -b sinatra-app https://github.com/n-shimada-gs/web_app.git
cd web_app
```

> `main` ブランチには タイトルだけのREADME.md のみが置かれています。アプリのコードは `sinatra-app` ブランチにあるため、`-b sinatra-app` を付けてクローンしてください。
>
> `main` の状態からクローンする場合は、以下でブランチを切り替えられます。
>
> ```bash
> git branch -a
> git checkout sinatra-app
> ```

### 2. Ruby のバージョンを合わせる

rbenv を使用している場合、リポジトリ内の `.ruby-version` に記載されたバージョンを自動で読み込みます。該当バージョンが未インストールの場合は以下を実行してください。

```bash
rbenv install
```

### 3. PostgreSQLをインストールする
  - データベース作成
  `createdb memoapp`
  (または: `psql -U postgres -f data/setup.sql`)
  - テーブル作成
  `psql -U postgres -d memoapp -f data/schema.sql`

### 4. gemをインストールする

```bash
bundle install
```

### 5. アプリケーションを起動する

```bash
bundle exec ruby app.rb
```

### 6. ブラウザでアクセスする

起動後、以下のURLにアクセスするとメモ一覧画面が表示されます。

```
http://localhost:4567
```

一覧画面の他に以下の画面・機能があります。
- メモ詳細画面
  - 既存メモ削除機能
  - 既存メモ編集機能・メモ編集画面
- 新規メモ作成画面

## ディレクトリ構成

```
.
├── app.rb              # アプリケーション本体
├── views/              # ERBテンプレート
│   └── index.erb
│   └── layout.erb
│   └── new.erb         # 新規メモ作成
│   └── edit.erb        # 既存メモ編集
│   └── not_found.erb
├── public/
│   └── stylesheets/
│       └── application.css
├── data/
│   └── setup.sql
│   └── schema.sql
├── .ruby-version
├── Gemfile
├── Gemfile.lock
└── README.md
```

## テーブル構成
`memodata`テーブルにメモを1件1行で保存しています。

| カラム  | 型    | 制約         |
|---------|-------|--------------|
| id      | uuid  | PRIMARY KEY  |
| title   | text  | NOT NULL     |
| details | text  | NOT NULL     |

`id`はDB側の自動採番ではなく、アプリ側（Ruby）で`SecureRandom.uuid`により生成しています。

**レビューのほどよろしくお願いいたします。**
