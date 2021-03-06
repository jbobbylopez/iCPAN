#!/usr/bin/env perl

use Modern::Perl;
use Data::Dump qw( dump );
use Every;
use Find::Lib '../lib';
use iCPAN;
use Time::HiRes qw( gettimeofday tv_interval );

my $t_begin = [gettimeofday];

my $attempts = 0;
my $every    = 20;
my $icpan    = iCPAN->new;
my $meta     = $icpan->meta_index;
$icpan->debug( $ENV{'DEBUG'} );

my @dists = @ARGV;
@ARGV = ();

# need to reset @ARGV in order to avoid this nasty error in Perl::Tidy
# "You may not specify any filenames when a source array is given"

if ( scalar @dists ) {
    foreach my $dist_name ( @dists ) {
        process_dist( $dist_name );
    }
}

else {
    my $schema      = $meta->schema;
    my $constraints = {};

    my $search
        = $meta->schema->resultset( 'iCPAN::Meta::Schema::Result::Module' )
        ->search( { name => { like => 'a%' } },
        { columns => ['dist'], distinct => 1, } );

    my @dist_list = ( );

    while ( my $row = $search->next ) {
        push @dist_list,  $row->dist;
    }

    foreach my $name ( sort @dist_list ) {
        my $dist = process_dist( $name );
    }

}

my $t_elapsed = tv_interval( $t_begin, [gettimeofday] );
say "Entire process took $t_elapsed";

sub process_dist {

    my $dist_name = shift;
    my $t0        = [gettimeofday];

    say '+'x20 . " DIST: $dist_name" if $icpan->debug;

    my $dist      = $icpan->dist( $dist_name );
    $dist->process;
    if ( $dist->tar ) {
        $dist->tar->clear;
    }

    my $iter_time = tv_interval( $t0,      [gettimeofday] );
    my $elapsed   = tv_interval( $t_begin, [gettimeofday] );

    ++$attempts;
    if ( every( $every ) ) {
        say "$dist_name";    # if $icpan->debug;
        say "$iter_time to process dist";
        say "$elapsed so far... ($attempts dists)";
    }

    return $dist;

}
