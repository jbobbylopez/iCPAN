package iCPAN::Role::Common;

use Moose::Role;

has 'debug' => (
    is         => 'rw',
    lazy_build => 1,
);

has 'minicpan' => (
    is         => 'rw',
    isa        => 'Str',
    lazy_build => 1,
);

#sub mod2file {
#
#    my $self        = shift;
#    my $module_name = shift;
#
#    my $file = $module_name;
#    $file =~ s{::}{-}gxms;
#    $file .= '.html';
#
#    return $file;
#}

sub file2mod {

    my $self        = shift;
    my $name = shift;

    $name =~ s{\Alib\/}{};
    $name =~ s{\.(pod|pm)\z}{};
    $name =~ s{\/}{::}gxms;

    return $name;
}

sub _build_debug {

    my $self = shift;
    return $ENV{'DEBUG'} || 0;

}

sub _build_minicpan {

    my $self = shift;
    return $ENV{'MINICPAN'} || "$ENV{'HOME'}/minicpan";

}

1;
