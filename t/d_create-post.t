#!/usr/bin/perl -wT

# create a new post

use strict;

use lib 'lib';
use lib 'lib/CPAN';

# use Test::More qw(no_plan);
use Test::More tests => 10;

BEGIN {
    use_ok('REST::Client');
    use_ok('JSON::PP');
    use_ok('Config::Config');
    use_ok('API::Utils');
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

my $date_time = Utils::create_datetime_stamp();

my %hash;

#### Post
$hash{post_text} = "# $date_time this will be the post title\n\nhere is the start of the body text\n\nhere is some more text.\n\n testin **markdown bolding**\n\nhashtag #test #perl";

$hash{submit_type} = "Post";

### Note
# $hash{post_text} = "$date_time this will be the title for a note that is intentionally longer than max post title len and max note title len which is more token than an acutal title since notes are viewed as titleless which suggests that maybe this feature should not exist in this blogging app.\n\nhere is the start of the body text\n\nhere is some more text.\n\n testin **markdown bolding**\n\nhashtag #test #perl";

### Draft
# $hash{post_text} = "# $date_time this will be the title\n\nhere is the start of the body text\n\nhere is some more text.\n\n testin **markdown bolding**\n\nhashtag #test #perl\n\ndraft=yes";


my $json = encode_json \%hash;

my $headers = {
    'Content-type' => 'application/x-www-form-urlencoded'
};

my $rest = REST::Client->new( {
    host => $api_url,
} );

my $pdata = {
    'json'       => $json,
    'user_name'  => $user_name,
    'user_id'    => $user_id,
    'session_id' => $session_id,
};
my $params = $rest->buildQuery( $pdata );

$params =~ s/\?//;

$rest->POST( "/posts" , $params , $headers );

my $rc = $rest->responseCode();

ok($rc >= 200 && $rc < 300, 'post successfully created.');

open($fh, ">", "t/post-info.json") or die "cannot open > post-info.json: $!";

print $fh $rest->responseContent() . "\n"; 

close($fh) or warn "close failed: $!";


