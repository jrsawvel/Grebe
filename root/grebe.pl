#!/usr/bin/perl -wT
use strict;
$|++;
use lib '/home/grebe/Grebe/lib';
use lib '/home/grebe/Grebe/lib/CPAN';

# if not useing redis, then only the following two lines are needed.
# use Client::Dispatch;
# Client::Dispatch::execute();
# 

use Redis;
my $domain_name = "somedomain.com";
my $cookies = $ENV{HTTP_COOKIE};
my $logged_in = 0;
if ( $cookies =~ m|grebeuserid=[1-9]+| ) {
    $logged_in = 1;
}
my $uri_info = $ENV{REQUEST_URI} . "/";
if ( !$logged_in and $uri_info eq '//' ) {
    my $key = "homepage";
    my $redis = Redis->new; 
    my $html = $redis->hget($domain_name, $key);
    if ( $html ) {
        print "Content-type: text/html;\n\n";
        print $html . "\n<!-- redis  -->\n";
        exit;
    } 
}
my @values = split(/\//, $uri_info);
if ( !$logged_in and $values[1] =~ m|^[0-9]+$| ) {
    my $key = $values[1];
    my $redis = Redis->new; 
    my $html = $redis->hget($domain_name, $key);
    if ( $html ) {
        print "Content-type: text/html;\n\n";
        print $html . "\n<!-- redis  -->\n";
        exit;
    } else {
        require Client::Dispatch;
        Client::Dispatch::execute();
    }
} else {
        require Client::Dispatch;
        Client::Dispatch::execute();
}
