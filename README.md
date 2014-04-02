cogoo-agent
===========

[COGOO](https://cogoo.jp)でコマンドラインから自転車を借りるためのコードです。

COGOOがW61SAに非対応だったのが悪い。

## install

    $bundle install

## usage
現状京都大学での利用が仮定されています。その他の場所で使う時はget\_bikeメソッドのspot\_id引数を変える必要があります。

    $bundle exec ruby cogoo-agent.rb

-yオプションをつけるとレンタル開始の前に確認を取りません。
