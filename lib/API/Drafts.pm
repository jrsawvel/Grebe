package Drafts;

use strict;

use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use API::Stream;
use API::Auth;
use API::Error;

sub drafts {
    my $tmp_hash = shift;

    my $q = new CGI;

    my $request_method = $q->request_method();

    my $user_auth;
    $user_auth->{user_name}    = $q->param("user_name");
    $user_auth->{user_id}      = $q->param("user_id");
    $user_auth->{session_id}   = $q->param("session_id");
    $user_auth->{logged_in_user_id} = 0;

    my $hash = Auth::authenticate_user($user_auth);
    if ( $hash->{status} == 200 ) {
        $user_auth->{logged_in_user_id} = $user_auth->{user_id};
    }

    if ( $request_method eq "GET" ) {
        Stream::get_post_stream($user_auth);
    } 
    Error::report_error("400", "Not found", "Invalid request");  
}

1;
