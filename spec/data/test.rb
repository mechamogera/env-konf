require '../../lib/env-konf'
#EnvKonf.encode(:key => "id_rsa_pub", :profile => "test", :path => "test.dat")
EnvKonf.decode(:key => "id_rsa", :profile => "test", :path => "test.dat")
