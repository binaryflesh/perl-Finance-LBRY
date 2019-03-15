package WWW::LBRY::API;

use Moo;
use JSON::RPC::Client;
use Scalar::Util qw( blessed );

has endpoint => (
    is => "rw", default => sub {
        "http://localhost:5279"
    }
);

has jsonrpc => (
    is => "lazy", default => sub {
        "JSON::RPC::Client"->new
    }
);

has error => (
    is => "rwp"
);

sub call
{
    my $self = shift;
    my ($method, @params) = @_;

    $self->_set_error(undef);

    my $return = $self->jsonrpc->call(
        $self->endpoint, {
            method  => $method,
            params  => \@params,
        }
    );

    if (blessed $return and $return->can('is_success') and $return->is_success)
    {
        $self->_set_error(undef);
        return $return->result;
    }
    elsif (blessed $return and $return->can('error_message'))
    {
        $self->_set_error($return->error_message);
        return;
    }
    else
    {
        $self->_set_error(sprintf('HTTP $s', $self->jsonrpc->status_line));
        return;
    }
}

1;

__END__

=head1 NAME

WWW::LBRY::API - wrapper for the LBRY JSON-RPC API

=head1 SYNOPSIS

use WWW::LBRY::API;

my $uri     = 'http://user:password@localhost:5279/';
my $api     = WWW::LBRY::API->new( endpoint => $uri );
my $balance = $api->call('getbalance');
print $balance;

=head1 DESCRIPTION

This module provides a low-level API for accessing a running LBRY instance.
See L<https://lbry.tech/api/sdk> and L<https://lbry.tech/api/blockchain> for supported calls.

=item C<< new ( %args ) >>

Constructor. %args is a hash of named arguments. Required parameter: 'endpoint'.

=item C<< call( $method, @params ) >>

Call a method.  returns the result if successful; otherwise undef.

=item C<< endpoint >>

The endpoint URI.

=item C<< jsonrpc >>

Retrieve a reference to the L<JSON::RPC::Client> object. C<< $api->jsonrpc->ua >> can be useful to alter settings.

=item C<< error >>

Returns the error message (if present) that resulted from the last 
C<call>.

=back

=head1 SEE ALSO
L<https://lbry.tech/api/blockchain>
L<https://lbry.tech/api/sdk>

=head1 AUTHOR

Logan Campos E<lt>logan.campos123@gmail.comE<gt>.

=head1 COPYRIGHT

Copyright 2019 Logan Campos

