#!/usr/bin/perl -wT

# compare versions

use strict;

use lib 'lib';
use lib 'lib/CPAN';

# use Test::More qw(no_plan);
use Test::More tests => 7;

BEGIN {
    use_ok('REST::Client');
    use_ok('JSON::PP');
    use_ok('Config::Config');
}

my $api_url = Config::get_value_for("api_url");
ok(defined($api_url), 'read api url from config file.');


#################### get current post info
my $json_input;

open(my $fh, "<", "t/full-post-info-logged-in-user.json") or die "cannot open < full-post-info-logged-in-user.json for read: $!";
while ( <$fh> ) {
    chomp;
    $json_input = $_; 
}
close($fh) or warn "close failed: $!";

ok(defined($json_input), 'old post info read from file.');

my $json_params  = decode_json $json_input;
my $left_id      = $json_params->{post_id};

ok(defined($left_id),     'post id parsed from json input.');


my $right_id = $left_id++;

$api_url .=  "/versions/$left_id/$right_id";
my $rest = REST::Client->new();
$rest->GET($api_url); 
my $rc = $rest->responseCode();

ok($rc >= 200 && $rc < 300 , 'comparing two post versions was successful.');

open($fh, ">", "t/version-compare.json") or die "cannot open > version-compare.json for read: $!";
print $fh $rest->responseContent() . "\n";
close($fh) or warn "close failed: $!";
