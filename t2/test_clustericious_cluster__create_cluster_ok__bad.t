use strict;
use warnings;
use Test2::Bundle::Extended;
use Test::Clustericious::Cluster;

plan 1;

is(
  intercept { Test::Clustericious::Cluster->new->create_cluster_ok( qw( Foo Bar ) ) },
  array {
    event Note => sub {
      call message => match qr{\[extract\] DIR  .*/my_home/lib$};
    };
    event Note => sub {
      call message => match qr{\[extract\] FILE .*/my_home/lib/(Foo|Bar)\.pm$};
    };
    event Ok => sub {
      call pass => F();
      call name => 'created cluster';
    };
    event Diag => sub {
      # generated by TB / T2
    };
    if(Test::Clustericious::Cluster->isa('Test::Builder::Module'))
    {
      event Diag => sub {
        # generated by TB / T2
      };
    }
    event Diag => sub {
      call message => match qr{^exception: };
    };
    end;
  },
  'invalid config'
);

__DATA__

@@ lib/Foo.pm
package Foo;

use strict;
use warnings;
use Mojo::Base qw( Mojolicious );

sub startup
{
  my $self = shift;
  $self->routes->get('/' => sub {
    shift->render(text => "Foo");
  });
}

1;
