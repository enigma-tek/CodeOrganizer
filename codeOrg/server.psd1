@{
    Port = '8089'
    Address = '*'
    Protocol = 'Http'
    Hostname = 'localhost'
    Server = @{ 
  
        Ssl= @{
            Protocols = @('TLS12')
        }
        Logging = @{
            Masking = @{
                Patterns = @('(?<keep_before>Password=)\w+')
            }
        }
        Request = @{
            Timeout = 900
        }
    }
    Service = @{ }
    Web = @{
	    Static = @{
            Cache = @{
                Enable = $false
            }
        }
 }
    Smtp = @{ }
    Tcp = @{ }
}