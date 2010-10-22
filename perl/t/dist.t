#!/usr/bin/perl

use Data::Dump qw( dump );
use Modern::Perl;
use Test::More qw( no_plan );

require_ok( 'iCPAN' );
require_ok( 'iCPAN::Dist' );

my $icpan = iCPAN->new;
my $meta  = iCPAN->meta_index;

#isa_ok( $dist, 'iCPAN::Dist' );

my $distro = $meta->schema->resultset( 'iCPAN::Meta::Schema::Result::Module' )
    ->find( { name => 'Moose' } );

diag( $distro->name );
