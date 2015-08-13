## check-bind2route53

bindからroute53へ移行した際に設定が正しいかを検証するツール


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
$ wget https://github.com/tjinjin/check-bind2route53/check-bind2route53.sh
```

* 実行する

```
$ check-bind2route53.sh <domain> <nameserver>
```
