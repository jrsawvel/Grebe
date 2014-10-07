#!/usr/bin/perl -wT
use strict;
$|++;
use lib '/home/grebe/Grebe/lib';
use lib '/home/grebe/Grebe/lib/CPAN';
use API::DispatchAPI;
API::DispatchAPI::execute();

# use Grebe::Homepage;
# Homepage::show_homepage();
