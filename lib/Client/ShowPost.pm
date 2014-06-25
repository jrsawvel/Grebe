package ShowPost;

use strict;
use REST::Client;
use JSON::PP;
use HTML::Entities;

sub show_post {
    my $tmp_hash = shift;  

    my $user_name    = User::get_logged_in_username(); 
    my $user_id      = User::get_logged_in_userid(); 
    my $session_id   = User::get_logged_in_sessionid(); 
#    my $query_string = "/?user_name=$user_name&user_id=$user_id&session_id=$session_id&text=html";
    my $query_string = "/?user_name=$user_name&user_id=$user_id&session_id=$session_id";

#    my $post = $tmp_hash->{one}; 
    my $post;

# when supporting the access to a post by either post_id or uri_title
#    if ( defined($tmp_hash->{one}) ) {
#        $post = $tmp_hash->{one}; 
#    } else {
#        $post = $tmp_hash->{function}; 
#    }


    my $t;

    if ( $tmp_hash->{function} eq "post" ) {
        $post = $tmp_hash->{one}; 
    } elsif ( $user_id < 1 and StrNumUtils::is_numeric($tmp_hash->{function}) ) {
        $t = Page->new($tmp_hash->{function}, 1);
        if ( $t->is_error() ) {
            $post = $tmp_hash->{function}; 
        } else {
            my $str = $tmp_hash->{one};
            $str =~ s|[-]| |g;
            $t->display_page($str);
        }
    } else {
        $post = $tmp_hash->{function}; 
    }


    my $api_url = Config::get_value_for("api_url") . "/posts/" . $post;

    $query_string .= "&text=html";  

    my $rest = REST::Client->new();
    $api_url .= $query_string;
    $rest->GET($api_url);

    my $rc = $rest->responseCode();

    my $json = decode_json $rest->responseContent();

    if ( $rc >= 200 and $rc < 300 ) {

        # currently, notes, drafts, and articles are viewabble by everyone.
        # if wish to restrict notes and drafts to the logged-in authors, then investigate using this code:
        # if ( !$json->{reader_is_author} and $json->{post_type} ne "article" ) {
        #    Page->report_error("user", "Invalid access.", "Content does not exist.");
        # }

        $t = Page->new("post");

        my $save_markup = $json->{markup_text} .  "\n\n<!-- author_name: $json->{author_name} -->\n<!-- created_date: $json->{created_date} -->\n<!-- modified_date: $json->{modified_date} -->\n";

        $t->set_template_variable("cgi_app",                 "");
        $t->set_template_variable("post_id",              $json->{post_id});
        $t->set_template_variable("post_type",            $json->{post_type});
        $t->set_template_variable("parent_id",               $json->{parent_id});
        $t->set_template_variable("version",                 $json->{version});
        $t->set_template_variable("title",                   $json->{title}) if $json->{post_type} ne "note";
        $t->set_template_variable("uri_title",               $json->{uri_title});
        $t->set_template_variable("formatted_text",          decode_entities($json->{formatted_text}, '<>&'));
        $t->set_template_variable("author_name",             $json->{author_name});
        $t->set_template_variable("related_posts_count",  $json->{related_posts_count});
        $t->set_template_variable("created_date",            $json->{created_date});
        $t->set_template_variable("formatted_created_date",  $json->{formatted_created_date});
        $t->set_template_variable("reading_time",            $json->{reading_time});
        $t->set_template_variable("word_count",              $json->{word_count});
        $t->set_template_variable("reader_is_author",        $json->{reader_is_author});


        if ( $json->{modified_date} ne $json->{created_date} ) {
            $t->set_template_variable("modified", 1);
            $t->set_template_variable("modified_date",           $json->{modified_date});
            $t->set_template_variable("formatted_modified_date", $json->{formatted_modified_date});
        }

        if ( $json->{table_of_contents} ) {
            my @toc_loop = _create_table_of_contents($json->{formatted_text});
            if ( @toc_loop ) {
                $t->set_template_variable("usingtoc", "1");
                $t->set_template_loop_data("toc_loop", \@toc_loop);
            }    
        } else {
            $t->set_template_variable("usingtoc", "0");
        }

        if ( $json->{usingimageheader} ) {
            $t->set_template_variable("usingimageheader", 1);
            $t->set_template_variable("imageheaderurl", $json->{imageheaderurl});
        }

        if ( $json->{usinglargeimageheader} ) {
            $t->set_template_variable("usinglargeimageheader", 1);
            $t->set_template_variable("largeimageheaderurl", $json->{largeimageheaderurl});
        }

        $t->display_page($json->{title});
    } elsif ( $rc >= 400 and $rc < 500 ) {
            Page->report_error("user", "$json->{user_message}", $json->{system_message});
    } else  {
        Page->report_error("user", "Unable to complete request.", "Invalid response code returned from API.");
    }
}

sub show_post_source {
    my $tmp_hash = shift;  

    my $user_name    = User::get_logged_in_username(); 
    my $user_id      = User::get_logged_in_userid(); 
    my $session_id   = User::get_logged_in_sessionid(); 
    my $query_string = "/?user_name=$user_name&user_id=$user_id&session_id=$session_id&text=markup";

    my $post = $tmp_hash->{one}; 

    my $api_url = Config::get_value_for("api_url") . "/posts/" . $post;

    my $rest = REST::Client->new();
    $api_url .= $query_string;
    $rest->GET($api_url);

    my $rc = $rest->responseCode();

    my $json = decode_json $rest->responseContent();

    if ( $rc >= 200 and $rc < 300 ) {
        my $t = Page->new("contentsource");
        $t->set_template_variable("markup_text", decode_entities($json->{markup_text}, '<>&'));
        $t->print_template("Content-type: text/plain");
    } elsif ( $rc >= 400 and $rc < 500 ) {
            Page->report_error("user", "$json->{user_message}", $json->{system_message});
    } else  {
        Page->report_error("user", "Unable to complete request.", "Invalid response code returned from API.");
    }
}

sub _create_table_of_contents {
    my $str = shift;

    my @headers = ();
    my @loop_data = ();

    if ( @headers = $str =~ m{<!-- header:([1-6]):(.*?) -->}igs ) {
        my $len = @headers;
        for (my $i=0; $i<$len; $i+=2 ) {
            my %hash = ();
            $hash{level}      = $headers[$i];
            $hash{toclink}    = $headers[$i+1];
            $hash{cleantitle} = _clean_title($headers[$i+1]);
            push(@loop_data, \%hash); 
        }
    }

    return @loop_data;    
}

sub _clean_title {
    my $str = shift;
    $str =~ s|[-]||g;
    $str =~ s|[ ]|-|g;
    $str =~ s|[:]|-|g;
    $str =~ s|--|-|g;
    # only use alphanumeric, underscore, and dash in friendly link url
    $str =~ s|[^\w-]+||g;
    return $str;
}

1;