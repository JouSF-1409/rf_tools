#!/usr/bin/env perl
use strict;
use warnings;
use File::Basename;

# split 3 col file to different files according to 2nd col


my ($min,$step,$file) = @ARGV;
open( my $ORI,"<",$file);
my $basefile = "split_";
open(my $OUTPUT,">>",$basefile."${min}_.lst");
print $basefile;

foreach my $line (<$ORI>) {
    my ($trace, $value,$junk) = split(/\s+/,$line);
    if($value >$min+$step){
        close $OUTPUT;
        $min+=$step;
        open($OUTPUT,">>",$basefile."${min}_.lst");
        redo;
    }
    print $OUTPUT "$trace\t$value\t$junk\n";
}
close $OUTPUT;


