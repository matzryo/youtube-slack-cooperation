# README

## AWS Lambdaへのデプロイ

ZIPファイルをAWS lambdaに送る。

```bash
zip -r function.zip main.rb slack.rb youtube.rb vendor .env youtube-quickstart-ruby-credentials.yaml client_secret.json
```