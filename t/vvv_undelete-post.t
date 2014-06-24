#!/usr/bin/perl -wT

# undelete an post

use strict;

use lib 'lib';
use lib 'lib/CPAN';

# use Test::More qw(no_plan);
use Test::More tests => 11;

BEGIN {
    use_ok('REST::Client');
    use_ok('JSON::PP');
    use_ok('Config::Config');
}

my $api_url = Config::get_value_for("api_url");
ok(defined($api_url), 'read api url from config file.');

my $json_input;

open(my $fh, "<", "t/logged-in-info.json") or die "cannot open < logged-in-info.json for read: $!";
while ( <$fh> ) {
    chomp;
    $json_input = $_; 
}
close($fh) or warn "close failed: $!";

ok(defined($json_input), 'login info read from file.');

my $json_params  = decode_json $json_input;
my $user_id      = $json_params->{user_id};
my $user_name    = $json_params->{user_name};
my $session_id   = $json_params->{session_id};

ok(defined($user_id),     'user id parsed from json input.');
ok(defined($user_name),   'user name parsed from json input.');
ok(defined($session_id),  'session id parsed from json input.');



open($fh, "<", "t/post-info.json") or die "cannot open < post-info.json for read: $!";
while ( <$fh> ) {
    chomp;
    $json_input = $_; 
}
close($fh) or warn "close failed: $!";

ok(defined($json_input), 'post info read from file.');

$json_params   = decode_json $json_input;
my $post_id = $json_params->{post_id};

# $post_id=12345; #test trying to read post that does not exist

ok(defined($post_id),     'post id parsed from json input.');

my $query_string = "/?user_name=$user_name&user_id=$user_id&session_id=$session_id&action=undelete";

$api_url .=  '/posts/' . $post_id;
my $rest = REST::Client->new();
$api_url .= $query_string;
$rest->GET($api_url); 
my $rc = $rest->responseCode();

ok($rc >= 200 && $rc < 300 , 'post was successfully undeleted  by author.');

open($fh, ">", "t/undeleted-post-info.json") or die "cannot open > undeleted-post-info.json for read: $!";
print $fh $rest->responseContent() . "\n";
close($fh) or warn "close failed: $!";
