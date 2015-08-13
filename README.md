## check-bind2route53

bindからroute53へ移行した際に設定が正しいかを検証するツール

## Requirement
* ruby
* bash (>4)
* voyagegroup/bind2route53

## Use
* bind2route53をgit cloneする

```
$ git@github.com:voyagegroup/bind2route53.git
$ cd bind2route53
```

* AWSへのアクセス情報を設定する

```
$ vim config/default.yml
```

* wgetでこのツールを落とす

```
$ wget https://github.com/tjinjin/check-bind2route53/blob/master/check-bind2route53.sh
```

* 実行する

```
$ check-bind2route53.sh <domain> <nameserver>
```

* 実行結果イメージ
```
$ ./aaa.sh example.jp @ns-xxx.awsdns-yy.net.
domain: ExampleJp
www.example.jp: success
api.example.jp: fail
```
