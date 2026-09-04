# web_app
# メモアプリ

**Webアプリケーション**プラクティス・**Sinatraを使ってWebアプリケーションの基本を理解する**の提出物です。

## 使用技術

- ruby "4.0.6"
- Sinatra "4.2.0"
- puma "8.0.0"
- rackup "2.3.0"
- データ保存: JSON ファイル（`data/memo.json` ）

## 動作環境

- Ruby（バージョンは `.ruby-version` を参照。rbenv でのバージョン管理を想定しています）
- Bundler

## セットアップ手順

### 1. リポジトリを取得する

```bash
git clone https://github.com/n-shimada-gs/web_app.git
cd web_app
```

### 2. Ruby のバージョンを合わせる

rbenv を使用している場合、リポジトリ内の `.ruby-version` に記載されたバージョンを自動で読み込みます。該当バージョンが未インストールの場合は以下を実行してください。

```bash
rbenv install
```

### 3. 依存gemをインストールする

```bash
bundle install
```

### 4. アプリケーションを起動する

```bash
bundle exec ruby app.rb
```

### 5. ブラウザでアクセスする

起動後、以下のURLにアクセスするとメモ一覧画面が表示されます。

```
http://localhost:4567
```

一覧画面の他に以下の画面・機能があります。
- メモ詳細画面
  - 既存メモ削除機能
  - 既存メモ編集機能・メモ編集画面
- 新規メモ作成画面

レビューの際の動作確認用として、一つメモを残したまま提出しています。
クローンした際のJSON ファイル（`data/memo.json` ）にデータが入っています。

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
│   └── memos.json      # メモデータ（JSON）
├── .ruby-version
├── Gemfile
├── Gemfile.lock
└── README.md
```
**レビューのほどよろしくお願いいたします。**
