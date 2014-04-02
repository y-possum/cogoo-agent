cogoo-agent
===========

[COGOO](https://cogoo.jp)でコマンドラインから自転車を借りるためのコードです。

COGOOがW61SAに非対応だったのが悪い。

## install
COGOOでの会員登録、並びに利用場所登録が必要です。

はじめに使う時は所属学部学科が聞かれるようですがそれには対応していません。
携帯端末向けサイト https://cogoo.jp/sp/ に一度ブラウザで行っておくと良いです。

cogoo-agent自体は

    $bundle install

でおしまいです。

## usage
現状京都大学での利用が仮定されています。その他の場所で使う時はget\_bikeメソッドのspot\_id引数を変える必要があります。

    $bundle exec ruby cogoo-agent.rb

-yオプションをつけるとレンタル開始の前に確認を取りません。
