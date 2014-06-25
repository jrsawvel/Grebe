#!/usr/bin/perl -wT

# read version lsit for post

use strict;

use lib 'lib';
use lib 'lib/CPAN';

# use Test::More qw(no_plan);
use Test::More tests => 8;

BEGIN {
    use_ok('REST::Client');
    use_ok('JSON::PP');
    use_ok('Config::Config');
}

my $api_url = Config::get_value_for("api_url");
ok(defined($api_url), 'read api url from config file.');

my $json_input;

# open(my $fh, "<", "t/post-info.json") or die "cannot open < post-info.json for read: $!";
open(my $fh, "<", "t/full-post-info-logged-in-user.json") or die "cannot open < full-post-info-logged-in-user.json for read: $!";
while ( <$fh> ) {
    chomp;
    $json_input = $_; 
}
close($fh) or warn "close failed: $!";

ok(defined($json_input), 'post info read from file.');

my $json_params   = decode_json $json_input;
my $post_id = $json_params->{post_id};
my $uri_title  = $json_params->{uri_title};

ok(defined($post_id),     'post id parsed from json input.');
ok(defined($uri_title),      'uri title parsed from json input.');

$api_url .=  '/versions/' . $post_id;
# $api_url .=  '/versions/' . $uri_title;
my $rest = REST::Client->new();
$rest->GET($api_url); 
my $rc = $rest->responseCode();

ok($rc >= 200 && $rc < 300 , 'reading post was successful.');

open($fh, ">", "t/version-list.json") or die "cannot open > version-list.json for read: $!";
print $fh $rest->responseContent() . "\n";
close($fh) or warn "close failed: $!";