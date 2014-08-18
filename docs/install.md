# Installing Grebe

Instructions as of July 30, 2014.

Documenting the steps, which will lead to additional programming changes to make it simpler. These instructions include creating a subdomain, Nginx server block, and setting up MySql. Some of this info may be split out into another file.


## Edit DNS

With the hosting provider, add DNS information, if necessary. 

Create a CNAME record if installing the code under a subdomain.  
`grebe CNAME @`

May have to wait a while before DNS updates in order to use the new subdomain website. 


## Edit Nginx Config

Log onto remote server.

Change to user `root` or use `sudo` ahead of each command. <https://help.ubuntu.com/community/RootSudo>

Change directory to web server config area. This example uses the Nginx web server, and it assumes that FastCGI has been installed.  
`cd /etc/nginx`

Need to create a server block config file to support Grebe. <http://wiki.nginx.org/ServerBlockExample>

> *"VirtualHost" is an Apache term. Nginx does not have Virtual hosts, it has "Server Blocks" that use the server_name and listen directives to bind to tcp sockets.*

This is an example of using Grebe under a subdomain.  
`cd sites-available`  
`vim grebe.yourdomain.com`
  
add the following lines and save the file:

    ########
    # GREBE
    ########
    server {
            listen   80;
    
            server_name grebe.yourdomain.com;
    
            location ~ ^/(css/|javascript/|images/) {
                root /home/grebe/Grebe/root;
                access_log off;
              expires max;
            }

            location /api/v1 {
                 root /home/grebe/Grebe/root/api/v1;
                 index grebeapi.pl;
                 rewrite  ^/(.*)$ /grebeapi.pl?query=$1 break;
                 fastcgi_pass  127.0.0.1:8999;
                 fastcgi_index grebeapi.pl;
                 fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                 include fastcgi_params;
            }
    
            location / {
                root /home/grebe/Grebe/root;
                index grebe.pl;
                rewrite  ^/(.*)$ /grebe.pl?query=$1 break;
                fastcgi_pass  127.0.0.1:8999;
                fastcgi_index grebe.pl;
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                include fastcgi_params;
            }
    }

Create a link to the new Nginx server block file.  
`ln -s /etc/nginx/sites-available/grebe.yourdomain.com /etc/nginx/sites-enabled/`

Restart Nginx.  
`/etc/init.d/nginx restart`


## Unpack Grebe

Create a home directory for Grebe.  
`mkdir /home/grebe`

Change to Grebe directory.  
`cd /home/grebe`

Create directories that will host markup and HTML template files that represent the posts created. These directories exist outside of document root, but they are used by the Grebe code.  
`mkdir posts`  
`mkdir markup`

Within the `/home/grebe` directory, download or copy over the gzipped tar file that contains the Grebe code, and unpack it. 

Example file: `Grebe-29Jul2014.tar.gz`

Unpack in two steps:  
`gunzip Grebe-29Jul2014.tar.gz`  
`tar -xvf Grebe-29Jul2014.tar`

Or unpack in one step:  
`tar -zxvf Grebe-29Jul2014.tar.gz`

The unpacking creates a directory called `Grebe`.


## Change File Permissions

Change ownership of all contents under the Grebe directory to the owner (username) and group that Nginx operates under.  
`chown - R owner:group Grebe`

While in `/home/grebe` change directory to `Grebe`.  
`cd Grebe`


## View Directory Structure

For curiosity sake, show a listing of all files and subdirectories under Grebe:  
`ls -lR`

The directory structure under Grebe:

     - lib
     -- API
     -- Client
     -- Config
     -- CPAN
     --- Algorithm
     --- HTML
     --- JSON
     --- REST
     --- Text
     --- URI
     ---- Escape
     --- XML
     --- YAML
     -- JRS
     - nginx
     - root
     -- api
     --- v1
     -- css
     -- images
     -- javascript
     --- splitscreen
     - sql
     - t
     - tmpl
     - yaml


## Edit Perl Scripts

While at `/home/grebe/Grebe`, change to the web root directory.  
`cd root`

Edit the small file `grebe.pl`. Here is the entire file. Ensure of the proper directory structures after the `lib` commands.

    #!/usr/bin/perl -wT
    use strict;
    $|++;
    use lib '/home/grebe/Grebe/lib';
    use lib '/home/grebe/Grebe/lib/CPAN';
    use Client::Dispatch;
    Client::Dispatch::execute();

While in `/home/grebe/Grebe/root`, change directory to the version one API directory. Since we're under the web root directory for the Nginx web server, this directory is part of the API URL.  
`cd api/v1`

Edit the small file `grebeapi.pl`. Here is the entire file. Ensure of the proper directory structures after the `lib` commands.

    #!/usr/bin/perl -wT
    use strict;
    $|++;
    use lib '/home/grebe/Grebe/lib';
    use lib '/home/grebe/Grebe/lib/CPAN';
    use API::DispatchAPI;
    API::DispatchAPI::execute();


## Setup MySQL

Change to the directory that contains the database files.  
`cd /home/grebe/Grebe/sql`

This assumes that MySQL is installed.

Create a new database and database user for Grebe. If planning to use an existing database, then skip these steps.

Enter this command to get into the mysql command line interface: (it will ask for the root password)  
`mysql -uroot -p`

At the `mysql>` prompt, enter the following commands, one at a time:  

`create database grebe;`

`create user 'grebe'@'localhost' identified by 'set_your_password_here';`  

`grant all privileges on grebe.* to 'grebe'@'localhost';`

`flush privileges;`

`quit;`

Create the Grebe database tables.

`mysql -ugrebe -pyourpassword -D grebe < grebe-users.sql`

`mysql -ugrebe -pyourpassword -D grebe < grebe-posts.sql`

`mysql -ugrebe -pyourpassword -D grebe < grebe-tags.sql`

`mysql -ugrebe -pyourpassword -D grebe < grebe-sessionids.sql`


## Edit Grebe Configuration

Change directory to the location of the Config module.  
`cd /home/grebe/Grebe/lib/Config`

Edit `Config.pm` and make the appropriate directory location change for the variable `$yml_file` which points to the location of the Yaml configuration file.  
`my $yml_file = "/home/grebe/Grebe/yaml/grebe.yml";`

Change directory to the Yaml config file location.  
`cd /home/grebe/Grebe/yaml`

Edit the file `grebe.yml` and make the appropriate changes. 

For testing, enable debug mode.  
`debug_mode: 1`

Debug mode will send the password to the screen for account creation and requesting new password. If using the no-password-login feature, then the login activation link will be displayed in the browser and not emailed.

If `read_template: 1`, then the following files need linked from the `Grebe/tmpl` directory to the `posts` directory.
 
`ln -s /home/grebe/Grebe/tmpl/header.tmpl /home/grebe/posts`  

`ln -s /home/grebe/Grebe/tmpl/inc_headernav.tmpl /home/grebe/posts`  

`ln -s /home/grebe/Grebe/tmpl/footer.tmpl /home/grebe/posts`

## Access Site

Open web browser and enter the following URL:  
`http://grebe.yourname.com`

The site or blog app should load, displaying the default image header and other links.

Create a user account:  
`http://grebe.yourname.com/signup`

Login:  
`http://grebe.yourname.com/login`

## To-do

* provide info for using MailGun to send e-mails for creating accounts and for using the no-password-login feature.


