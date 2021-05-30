# discordrbのGemです
require 'discordrb'

# トークン等の設定をするために必要になります
require 'configatron'

# 設定関係です。ここでconfig.rbが生成されます。
if File.exist?("config.rb")
  puts "設定はすでに完了しています。"
else
  puts "設定ファイルがありません。\n*新規で実行した場合は必ず表示されます。\n設定を行います。\nBotはあらかじめ作成しておいて下さい。\nhttps://discord.com/developers/applications"
  puts "各設定内容は半角にて入力してください。\nBotのIDを入力してください。\n※IDの取得はDiscord Developer Portalから行うか、Discord設定から開発者モードを有効にして下さい。："
  bot_id = gets.chomp.to_i
  puts "次に、Botのトークンを入力してください。："
  bot_token = gets.chomp
  puts "Botのプレフィックスを入力してください。\n※便宜上3文字以内を推奨："
  bot_prefix = gets.chomp
  puts "最後に管理者のIDを入力して下さい。\n管理者はBotのシャットダウンなどの動作を行う事が出来ます。\n※IDの取得はDiscord設定から開発者モードを有効にしてください。："
  bot_admin = gets.chomp.to_i
  config_file = File.open("config.rb", "w")
  config_file.puts("# Bot情報設定ファイル ※このファイルの文章の変更は絶対に行わないで下さい。\nconfigatron.botid = #{bot_id}\nconfigatron.token = '#{bot_token}'\nconfigatron.prefix = '#{bot_prefix}'\nconfigatron.ownerid = #{bot_admin}")
  puts "設定が完了しました。正しく設定出来た場合はこのまましばらくお待ちください。\n設定間違え等がある場合は、ここで終了するか、Ctrl+Cを押した上で、config.rbを削除してから再度実行してください。"
  config_file.close
  sleep 3
end

# トークン等を書き込んでいるファイル(流出には注意してください。)
require_relative 'config.rb'

# インスタンスを作成します。 token:にトークンを入力します。(流出には注意してください。) client_id:にBotのIDを入力します。 prefix:にBotに設定したいプレフィックスを入力します。
bot = Discordrb::Commands::CommandBot.new token: configatron.token, client_id: configatron.botid , prefix: configatron.prefix

# 変数.message containingに書いているメッセージが含まれていると、実行されます。
# こんにちはとメッセージが入力されると実行します。
bot.message(containing: "こんにちは") do |event|
  event.respond "#{event.user.name}さん、こんにちは！"
end

# containingに括弧でくくって配列にすると、複数条件を作ることが出来ます(この場合ははじめましてか初めましてで実行されます。)
bot.message(containing: ["はじめまして","初めまして"]) do |event|
  event.respond "#{event.user.name}さん、#{event.server.name}へようこそ！"
end

# 変数.command 設定したプレフィックス+コマンドが入力されると、実行されます。
# プレフィックスhelloと入力されると実行されます。
# コマンドの他のオプションです。 
# description:ヘルプコマンドを入力したときに出てくる一覧の説明文になります
# usage: help [コマンド名]を入力した時に出てくるメッセージです。追加のヘルプなどをここに入力するといいかと思います。
# help_available helpコマンドを入力した時にこのコマンドを表示するか。falseで表示しないようになります。デフォルトはtrue
# その他使えるオプションはこちらをご参照下さい。 https://www.rubydoc.info/github/meew0/discordrb/Discordrb/Commands/CommandContainer
bot.command(:hello, description: "こんにちはメッセージを返します。", usage: "表示するだけです。引数はありません") do |event|
  # 現在時刻を取得します。
  time = Time.now
  # message変数を初期化します。
  message = ""
  # 時間を確認、メッセージ分岐
  # 時間が6未満であれば
  if time.hour < 6
    # 遅くまでお疲れ様をmessage変数に代入
    message = "遅くまでおつかれさま"
  # 時間が12未満であれば
  elsif time.hour < 12
    # おはようをmessage変数に代入
    message = "おはよう！"
  # 時間が17未満であれば
  elsif time.hour < 17
    # こんにちはをmessage変数に代入
    message = "こんにちは！"
  # 上記どれにも一致しなければ
  else
    # こんばんはをmessage変数に代入
    message = "こんばんは"
  end
  # Discordに送信
  event.respond "#{event.user.name}さん、#{message} 今の時間は#{time.hour}時#{time.min}分だよ"
end

# shutdownコマンドが入力されたとき
bot.command(:shutdown, help_available: false) do |event|
  # コマンド入力している人がオーナーかチェックします
  if event.user.id == configatron.ownerid
    # 終了しましたと送信(先に送信しておかないと切断されてしまう為)
    event.respond "終了しました"
    # botを切断
    bot.stop
  end
end

# ステータスをオンラインに変更する
bot.command(:online, help_available: false) do |event|
  if event.user.id == configatron.ownerid
    bot.online
    event.respond "Botはオンラインになりました。"
  end
end

# ステータスを退席中に変更する
bot.command(:idle, help_available: false) do |event|
  if event.user.id == configatron.ownerid
    bot.idle
    event.respond "Botは退席中になりました。"
  end
end

# ステータスを取り込み中に変更する
bot.command(:dnd, help_available: false) do |event|
  if event.user.id == configatron.ownerid
    bot.dnd
    event.respond "Botは取り込み中になりました"
  end
end

# ステータスをオンライン状態を隠すに変更する
bot.command(:invisible, help_available: false) do |event|
  if event.user.id == configatron.ownerid
    bot.invisible
    event.respond "Botはオンライン状態を隠しています\nこのコマンドを入力しても実際にシャットダウンされたわけではありません。\n終了するときはshutdownコマンドを入力してください。"
  end
end

# Botのステータスメッセージを変更する
# ～～をプレイ中
bot.command(:set_game, help_available: false) do |event,message|
  if event.user.id == configatron.ownerid
    bot.game = message
    event.respond "Botステータスメッセージを#{message}に変更しました。"
  end
end
# ちなみに、変数.game に nilを入れると、ステータスメッセージを消去出来ます。

# ～～を視聴中
bot.command(:set_watch, help_available: false) do |event,message|
  if event.user.id == configatron.ownerid
    bot.watching = message
    event.respond "Botステータスメッセージを#{message}に変更しました。"
  end
end

# ～～を再生中
bot.command(:set_play, help_available: false) do |event,message|
  if event.user.id == configatron.ownerid
    bot.listening = message
    event.respond "Botステータスメッセージを#{message}に変更しました。"
  end
end

# 最後に変数.runで起動します
bot.run