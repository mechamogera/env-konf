# Env::Konf

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'env-konf'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install env-konf

## Usage

### create prototype profile

 * you should edit profile manually after creating prototype profile
```
$ env-konf profile-init test
  create /home/hoge/.env-konf/test.yaml
```

### get profile value at your source code

```
require 'env-konf'

EnvKonf.profile = "test"
p EnvKonf.get
```

### create profile zip protected password

```
$ env-konf zip test.zip --profile test
Password: ********
Retype password: ********
  zip test.zip from /home/hoge/.env-konf/test.yaml
```

### unzip profile zip

```
$ env-konf unzip test.zip
Password: ********
  unzip to /home/hoge/.env-konf/test.yaml from test.zip
```

### save zip config setting

```
$ env-konf config --profile=test --check-password=password --target-path=./test.zip
  update .env-konf/config.yml
$ env-konf zip
Password: **
Password md5 miss match
Password: ********
  zip to ./test.dat from /home/hoge/.env-konf/test.yaml
```

### encode profile data

```
$ env-konf encode test.dat --profile=test --key=~/.ssh/id_rsa_pub
  encode to test.dat from /home/hoge/.env-konf/test.yaml
```

### decode profile data

```
$ env-konf decode test.dat --profile=test --key=~/.ssh/id_rsa
  decode to /home/hoge/.env-konf/test.yaml from test.dat
```

### save encode config setting

```
$ env-konf config --profile=test --target-path=test.dat --rsa-encode-key=~/.ssh/id_rsa_pub --rsa-decode-key=~/.ssh/id_rsa
$ env-konf encode
  encode to test.dat from /home/hoge/.env-konf/test.yaml
$ env-konf decode
  decode to /home/hoge/.env-konf/test.yaml from test.dat
```
