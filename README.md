# perl-Finance-LBRY
Perl5 binding for the LBRY JSON-RPC API

Usage:

```perl
	use Finance::LBRY::API;

	my $uri     = 'http://user:password@localhost:5279/';
	my $api     = Finance::LBRY::API->new( endpoint => $uri );
	my $balance = $api->call('getbalance');
	print $balance;
```

This module provides a low-level API for accessing a running LBRY 
instance.
See [SDK Daemon API Calls](https://lbry.tech/api/sdk) and 
[LBRYCRD API Calls](https://lbry.tech/api/blockchain) 
for supported calls.
