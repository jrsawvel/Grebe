# Grebe

Grebe is a multi-user blogging app or small CMS.

[Grebe help](http://grebe.soupmode.com/tag/help)

* [user documentation](http://grebe.soupmode.com/613/grebe-user-documentation)
* [formatting help](http://grebe.soupmode.com/610/grebe-formatting-help)
* [creating and editing tips](http://grebe.soupmode.com/612/grebe-creating-and-editing-tips)
* [formatting sandbox](http://grebe.soupmode.com/611/grebe-formatting-sandbox)


It's used at:

* <http://maketoledo.com>
* <http://birdbrainsbrewing.com>
* <http://toledowinter.com>
* <http://babyutoledo.com>

The test site is:  
<http://grebe.soupmode.com>

All of the above installations of Grebe make use of Memcached. When posts are created or updated, the HTML for the post and the HTML for the homepage are stuffed into Memcached.

Nginx checks Memcached to see if the post ID exists. If not, then the Grebe app gets launched, and the MySQL database gets accessed. But for most browsing-only users, they receive the Memcached version of a post.

String searches and tag searches hit the database.


Grebe includes the following:

* API-based, using REST and JSON. 
* Multiple user accounts permitted
* Customizable user profile page
* Post types: articles, drafts, and notes
* Markup support: Textile, Markdown, Multimarkdown, and some HTML
* Additional text commands to control formatting and functionality of a post
* Special embed commands for other media types
* Simple and enhanced (JavaScript) writing areas for blog posts
* Anyone can view the markup source
* Simple, post forms with little to no form elements
* Keeps old versions of posts
* Can compare differences
* Can revert back to old version
* Content headers are also links within the page
* Content headers can be used to create a table of contents for the page
* Display all posts by created date (default order) or by modified date
* Can display stream of posts by author
* Author can delete and undelete all posts when viewing the stream
* Basic string search
* Hashtags
* Can display tag list, sorted by name or count.
* Show related articles based upon hashtags
* Multiple RSS feeds
* Responsive design for mobile devices
* Font-Awesome icons used
* No client-side JavaScript is used except in the enhanced writing area.
* Option to login without a password by using e-mail to send login link
* Option to store the markup for each post on the hard drive
* Option to store the formatted content as an HTML Template on the hard drive. For logged out users, instead of pulling the content from the database, the option exists to display the article by using the template file. It's not 100 percent static, since the header and footer templates are dynamically included, but the database is not accessed.



