# Discordrb Bot
## 概要
このソースコードはDiscordrbを使ったBotです。
## Gemのインストールのやり方
```shell
gem install discordrb
gem install configatron
```

でインストールするか、
```shell
bundle install
```
でインストールできます。  
※事前にRubyはインストールしておいてください。Path環境変数が通っている必要があります。
## 起動する
bot.rbを実行してください。
```shell
ruby bot.rb
```
で実行できます。  
初めて起動したときは、Botのトークン、BotのID、Botに設定したいプレフィックス、オーナのIDを聞かれますので適切な値を入力してEnterキー(Returnキー)を押してください。  
間違って設定したときは、config.rbの適切な場所を書き換えるか、config.rbを削除してください。  
## 起動したBotを終了するときは...
起動したbotを終了するときは、Discordで、shutdownコマンドを入力するか、コンソールでCtrl+Cで終了してください。