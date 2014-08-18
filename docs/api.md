# Grebe API

This is Grebe's API description. It's currently used at <http://maketoledo.com> and <http://birdbrainsbrewing.com> with a test site at <http://grebe.soupmode.com>.

It uses REST and JSON.

Each function below is preceded with `/api/v1` in the URI, so for Make Toledo, it would be `http://maketoledo.com/api/v1`.

Example of activating a new user account:  
`http://maketoledo.com/api/v1/users/activate/ru8wkn0ol2ql3bm9`

Example of retrieving the posts that get displayed on the homepage at maketoledo.com:  
`http://maketoledo.com/api/v1/posts`

At the moment, I don't have SSL enabled for MakeToledo.com, and OAuth is not used. 

For GETs that require the user to be logged-in, the URI ends with the query string:  
`/?user_name=[user_name]&user_id=[user_id]&session_id=[session_id]`

POST and PUT requests will also need the above name=value pairs encoded and sent to the API.


### Users

* Create a new user account.  
POST request.  
`/users`  
Client sends JSON to the API:  
`{ "user_name" : "userA", "email"     : "usera@usera.com" }`


* Activate user account.  
GET request.  
`/users/activate/[user_digest]`


* Login user.  
Post request.  
`/users/login`  
Client sends JSON to the API:  
`{ "email"     : "usera@usera.com", "password" : "plaintextpwd" }`


* Retrieve profile page info for user name JR.  
GET request.  
`/users/JR`


* Logout user JR.  
GET request.  
`/users/JR/logout`


* Retrieve new password for existing account. User would not be logged in. This would be executed for someone who forgot or lost a password.  
POST request.  
`/users/password`  
Client sends JSON to the API:  
`{ "user_name" : "userA", "email"     : "usera@usera.com" }`


* Update password for existing account. User must be logged-in.  
PUT request.  
`/users/password`  
Client sends JSON to the API:  
`{ "old_password" : "oldpwdtext", "new_password"     : "newpwdtxt", "verify_password" : "newpwdtxt", "user_name" : "userA", "user_id" : 123 }`  


* Update e-mail and/or profile description for the user.  
PUT request.  
`/users`  
Client sends JSON to the API:  
`{ "user_name" : "userA", "user_id" : 123, "desc_markup" : "my profile page info for others to view.", "email" : "usera@usera.com" }`  


### Posts


* Show stream of posts.  
GET request.  
`/posts`  
`/posts/?type=note&author=jr`   
`/posts/?type=draft&author=jr`   
`/posts/?sortby=modified`  
`/posts/?page=3`  
`/posts/?author=jr`  
**To-Do:** support  
`/posts/?year=2014&month=05&day=02`


* Retrieve single post.  
GET request.  
`/posts/5`  
`/posts/5?/text=markup`  
`/posts/5/?text=html`  
`/posts/5/?text=full`  
**To-Do:** support  
`/posts/5/?fields=title,uri_title,created_date,etc.`


* Retrieve list of related posts.  
GET request.  
`/posts/5/?related=yes`


* Delete an post with ID number 5.  
`/posts/5/?action=delete`


* Undelete an post with ID number 5.  
`/posts/5/?action=undelete`


* Create a new post.  
POST request.   
`/posts`  
In addition to the name=value logged-in credentials listed above, the client sends the following JSON to the API:  
`{ "post_text" : "this is the post text." }`  
Sample returned JSON:  
`{"post_id":"9","status":201,"description":"Created"}`


* Update post with ID number 5.   
PUT request  
`/posts`  
In addition to the name=value logged-in credentials listed above, the client sends the following JSON to the API:  
`{ "post_id": "5", "post_digest": "ru48f9re39jf023jf", "post_text":"updated text"}`



### Versions

* Show version list for post ID 5  
`/versions/5`

* Compare two post versions based upon their numeric post IDs. This example compares post post ID 1 and post ID 2  
`/versions/1/2`


### Tags

* Show list of tags, sorted by name   
`/tags/?sortby=name`

* Show list of tags, sorted by count  
`/tags/?sortby=count`

* Show stream of posts for tag 'food.'  
`/tags/food`  
OR `/searches/tag/tagname` 


### Searches

* Search for the phrase "text string"  
`/searches/string/text+string`

* Retrieve page three of the search results for the phrase "text string"    
`/searches/string/text+string/3`

* Retrieve posts that contain mentions of both "Toledo" AND "Detroit"  
`/searches/string/toledo+AND+detroit`

* Retrieve posts that contain either mentions of "pizza" OR "bread"  
`/searches/string/pizza+OR+bread`

* Retrieve posts with the tag "food"  
`/searches/tag/food`

* Retrieve page three of the search results for tag "food"  
`/searches/tag/food/3`

* Retrieve posts that contain the tags "beer" AND "cheese"  
`/searches/tag/beer+AND+cheese`

* Retrieve posts that contain either the tags "fishing" OR "cycling"  
`/searches/tag/fishing+OR+cycling`


