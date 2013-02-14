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
```

### unzip profile zip

```
$ env-konf unzip test.zip
Password: ********
```

### save zip config setting

```
$ env-konf zip-config --profile=test --check-password=password --zip-path=./test.zip
$ env-konf zip
Password: **
Password md5 miss match
Password: ********
```
