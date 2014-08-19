# Grebe Feature List

Grebe is a small blogging tool.


## Features

* API-based, using REST and JSON. 
* Multiple user accounts permitted
* Customizable user profile page
* Post types: articles, drafts, and notes
* Markup support: Textile, Markdown, Multimarkdown, and some HTML
* Additional text commands to control formatting and functionality of a post
* Special embed commands for other media types
* Simple and enhanced writing areas for blog posts
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
* Text resizer for the entire site
* Responsive design for mobile devices
* Font-Awesome icons used
* No client-side JavaScript is used except in the enhanced writing area.
* Option to login without a password by using e-mail to send login link
* Option to store the markup for each post on the hard drive
* Option to store the formatted content as an HTML Template on the hard drive. For logged out users, instead of pulling the content from the database, the option exists to display the article by using the template file. It's not 100 percent static, since the header and footer templates are dynamically included, but the database is not accessed.


## To-Dos

* Add a feature (archives display) to access all posts based upon:
  * year
  * month and year
  * month, year, and day


## Possible To-Dos

I have not decided whether to add these features that exist in my Junco web publishing app. 

* Add the double-bracket command to link to **existing** blog articles by placing the title within the double brackets.
* Add the double curly brace command and the related tmpl. and tmpl.. commands to include content from one article into another article.
* Accept Webmentions as the only reply method. Two ways to accept a Webmention:
  * programmatically access the Webmention endpoint URL
  * manually copy-and-paste the reply URL into a text input field for the Grebe article being replied to


