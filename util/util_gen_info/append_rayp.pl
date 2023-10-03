#!/usr/bin/env perl
# append ray_para to user0 
# run this script like perl append_rayp.pl dirname phase
# if you want a different suffix, modify line 11,14
use strict;
use warnings;

my ($dir,$phase) = @ARGV;
chdir $dir or die "failing while changing to $dir\n";

foreach my $info (split(/\n/,`saclst gcarc evdp f *.ri`)){
    my ($trace, $gcarc, $evdp) = split(/\s+/,$info);
    my $rayp = `taup time -ph $phase -h $evdp -deg $gcarc --rayp`/111.2;
    $trace =~ s/ri$/\[rt\]i/;
    `sachd user0 $rayp user1 $rayp f $trace`;
}
