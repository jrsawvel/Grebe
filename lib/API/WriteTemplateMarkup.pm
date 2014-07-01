package WriteTemplateMarkup;

use strict;

use HTML::Entities;
use JRS::Page;
use API::GetPost;

sub output_template_and_markup {
    my $logged_in_user_id = shift;
    my $post_id           = shift;
   
    my %user_auth;
    $user_auth{logged_in_user_id} = $logged_in_user_id;

    my $hash_ref = GetPost::get_post(\%user_auth, $post_id, "private");

    _output_template($hash_ref) if Config::get_value_for("write_template");
    _output_markup($hash_ref)   if Config::get_value_for("write_markup");
}

sub _output_template {
    my $hash_ref = shift;

    my $t = Page->new("inc_post");

    $t->set_template_variable("cgi_app",                 "");
    $t->set_template_variable("post_id",                 $hash_ref->{post_id});
    $t->set_template_variable("post_type",               $hash_ref->{post_type});
    $t->set_template_variable("parent_id",               $hash_ref->{parent_id});
    $t->set_template_variable("version",                 $hash_ref->{version});
    $t->set_template_variable("title",                   $hash_ref->{title}) if $hash_ref->{post_type} ne "note";
    $t->set_template_variable("uri_title",               $hash_ref->{uri_title});
    $t->set_template_variable("formatted_text",          decode_entities($hash_ref->{formatted_text}, '<>&'));
    $t->set_template_variable("author_name",             $hash_ref->{author_name});
    $t->set_template_variable("related_posts_count",     $hash_ref->{related_posts_count});
    $t->set_template_variable("created_date",            $hash_ref->{created_date});
    $t->set_template_variable("formatted_created_date",  $hash_ref->{formatted_created_date});
    $t->set_template_variable("reading_time",            $hash_ref->{reading_time});
    $t->set_template_variable("word_count",              $hash_ref->{word_count});

    if ( $hash_ref->{modified_date} ne $hash_ref->{created_date} ) {
        $t->set_template_variable("modified", 1);
        $t->set_template_variable("modified_date",           $hash_ref->{modified_date});
        $t->set_template_variable("formatted_modified_date", $hash_ref->{formatted_modified_date});
    }

    if ( $hash_ref->{table_of_contents} ) {
        my @toc_loop = _create_table_of_contents($hash_ref->{formatted_text});
        if ( @toc_loop ) {
            $t->set_template_variable("usingtoc", "1");
            $t->set_template_loop_data("toc_loop", \@toc_loop);
        }    
    } else {
        $t->set_template_variable("usingtoc", "0");
    }

    if ( $hash_ref->{usingimageheader} ) {
        $t->set_template_variable("usingimageheader", 1);
        $t->set_template_variable("imageheaderurl", $hash_ref->{imageheaderurl});
    }

    if ( $hash_ref->{usinglargeimageheader} ) {
        $t->set_template_variable("usinglargeimageheader", 1);
        $t->set_template_variable("largeimageheaderurl", $hash_ref->{largeimageheaderurl});
    }

    # write html of the post to the file system as an HTML::Template file.
    my $tmpl_output = $t->create_html($hash_ref->{title});
    $tmpl_output = "<!-- tmpl_include name=\"header.tmpl\" -->\n" . $tmpl_output . "\n<!-- tmpl_include name=\"footer.tmpl\" -->\n";
    my $filename = Config::get_value_for("post_templates") . "/" . $hash_ref->{post_id} . ".tmpl"; 
    if ( $filename =~  m/^([a-zA-Z0-9\/\.\-_]+)$/ ) {
        $filename = $1;
    } else {
        Error::report_error("500", "Bad file name.", "Could not write template for post id: $hash_ref->{post_id} filename: $filename");
    }
    open FILE, ">$filename" or Error::report_error("500", "Unable to open file for write.", "Post id: $hash_ref->{post_id} filename: $filename");
    print FILE $tmpl_output;
    close FILE;
}

sub _output_markup {
    my $hash_ref = shift;

    my $save_markup = $hash_ref->{markup_text} .  "\n\n<!-- author_name: $hash_ref->{author_name} -->\n<!-- created_date: $hash_ref->{created_date} -->\n<!-- modified_date: $hash_ref->{modified_date} -->\n";

    # write markup (multimarkdown or textile) to the file system.
    my $markup_filename = Config::get_value_for("post_markup") . "/" . $hash_ref->{post_id} . ".markup"; 
    if ( $markup_filename =~  m/^([a-zA-Z0-9\/\.\-_]+)$/ ) {
        $markup_filename = $1;
    } else {
        Error::report_error("500", "Bad file name.", "Could not write markup for post id: $hash_ref->{post_id} filename: $markup_filename");
    }
    open FILE, ">$markup_filename" or Error::report_error("user", "Unable to open file for write.", "Post id: $hash_ref->{post_id} filename: $markup_filename");
    print FILE $save_markup;
    close FILE;
}

1;
