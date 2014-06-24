#!/usr/bin/perl -wT

# display tag list

use strict;

use lib 'lib';
use lib 'lib/CPAN';

# use Test::More qw(no_plan);
use Test::More tests => 5;

BEGIN {
    use_ok('REST::Client');
    use_ok('JSON::PP');
    use_ok('Config::Config');
}

my $api_url = Config::get_value_for("api_url");
ok(defined($api_url), 'read api url from config file.');

$api_url .=  '/tags/?sortby=name'; 

my $rest = REST::Client->new();

$rest->GET($api_url); 

my $rc = $rest->responseCode();

ok($rc >= 200 && $rc < 300 , 'reading list of tag names and counts sorted by name.');

open(my $fh, ">", "t/tag-list-by-name.json") or die "cannot open > tag-list-by-name.json for read: $!";
print $fh $rest->responseContent() . "\n";
close($fh) or warn "close failed: $!";
