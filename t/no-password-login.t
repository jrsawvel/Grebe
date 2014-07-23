#!/usr/bin/perl -wT

# no-password-login.t
# login without a password

use strict;

use lib 'lib';
use lib 'lib/CPAN';

# use Test::More qw(no_plan);
use Test::More tests => 9;

BEGIN {
    use_ok('REST::Client');
    use_ok('JSON::PP');
    use_ok('Config::Config');
}

my $api_url = Config::get_value_for("api_url");
ok(defined($api_url), 'read api url from config file.');

my $json_input;

open(my $fh, "<", "t/new-user-info.json") or die "cannot open < new-user-info.json for read: $!";
while ( <$fh> ) {
    chomp;
    $json_input = $_; 
}
close($fh) or warn "close failed: $!";

ok(defined($json_input), 'user info read from file.');

my $json_params  = decode_json $json_input;
my $email        = $json_params->{email};
my $password     = $json_params->{password};

ok(defined($email),    'account email parsed from json input.');
ok(defined($password), 'account password parsed from json input.');

my %hash;
$hash{user_digest}     = "Oc0iiX2Jdq5J7IuijZtA"; 
$hash{password_digest} = "y23LWwAxeFR6FLPK4nInmg";
my $json = encode_json \%hash;

my $headers = {
    'Content-type' => 'application/x-www-form-urlencoded'
};

my $rest = REST::Client->new( {
    host => $api_url,
} );

my $pdata = {
    'json' => $json,
};
my $params = $rest->buildQuery( $pdata );

$params =~ s/\?//;

$rest->POST( "/users/nopwdlogin" , $params , $headers );

my $rc = $rest->responseCode();

ok($rc >= 200 && $rc < 300, 'user account successfully logged in.');

$json_params = decode_json $rest->responseContent();

ok(defined($json_params->{session_id}), 'user digest returned.');

open($fh, ">", "t/no-password-logged-in-info.json") or die "cannot open > no-password-logged-in-info.json: $!";

print $fh $rest->responseContent() . "\n"; 

close($fh) or warn "close failed: $!";

