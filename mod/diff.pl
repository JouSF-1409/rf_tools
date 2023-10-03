#!/usr/bin/env perl
# gen model for cal piercing point
# change models from depth vp vs rho
# to thickness vp vs
use strict;
use warnings;

unlink "iasp91.pierce";
open(my $OR,"<","./tmp");
open(my $OUT,">>","iasp91.pierce");
my $last=0;
while (<$OR>){
    chomp;
    my ($depth,$vp,$vs,$rho) = split(/\s+/,$_);

    next if($depth == $last);

    my $thickness = $depth - $last;
    print $OUT "$thickness\t$vp\t$vs\n";
    $last = $depth;
}
close $OR;close $OUT;
