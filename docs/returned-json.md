# Grebe API Returned JSON


## Created a new user account.

    {
        "email":"testuser1403714996@test.com",
        "password":"hx7epyyd",
        "user_digest":"Afvh7gO1t9a8ptJSqVzITg",
        "status":201,
        "user_id":"4",
        "description":"Created",
        "user_name":"testuser1403714996"
    }


## Logged-in.

    {
        "session_id":"rvBvLDXmPjohnbiTM9t2MQ",
        "status":200,
        "user_id":"4",
        "description":"OK",
        "user_name":"testuser1403714996"
    }



## Updated password.

    {
        "session_id":"BSif8wk2iqSks6QNXIySw",
        "status":200,
        "user_id":"4",
        "user_name":"testuser1403714996"
    }



## Created an article, note, or draft post.

    {
        "status":200,
        "post_id":"119",
        "description":"Created"
    }



## Updated an article, note, or draft post.

    {
        "status":201,
        "post_id":"121",
        "description":"Updated"
    }


### Version list for a post.

    {
        "author_name":"testuser1403714996",
        "formatted_modified_date":"Jun 25, 2014",
        "status":200,
        "version":"2",
        "description":"OK",
        "post_id":"121",
        "formatted_modified_time":"11:49:59 AM",
        "title":"new UPDATED post text 2014-06-25 16:49:59",
        "uri_title":"new-updated-post-text-20140625-16-49-59",
        "edit_reason":null,
        "version_list":[
            {
                "version_date":"Jun 25, 2014",
                "author_name":"testuser1403714996",
                "version_time":"11:49:58 AM",
                "version":"1",
                "post_id":"122",
                "uri_title":"20140625-16-49-58-this-will-be-the-post-title",
                "edit_reason":null
            }
        ]
    }



## Version compare info.

    {
    "top_version":
        {
            "author_id":"4",
            "author_name":"testuser1403714996",
            "markup_text":"# new UPDATED post text 2014-06-25 16:49:59\n\nhere is some more text.\n\ntags #grebe #blogging",
            "formatted_text":"<p>here is some more text.</p>\n\n<p>tags <a href=\"/tag/grebe\">#grebe</a> <a href=\"/tag/blogging\">#blogging</a></p>\n\n",
            "parent_id":"0",
            "formatted_modified_time":"11:49:59 AM",
            "post_id":"121",
            "post_type":"article",
            "edit_reason":null,
            "formatted_modified_date":"Jun 25, 2014",
            "modified_date":"2014-06-25 16:49:59",
            "version":"2",
            "created_date":"2014-06-25 16:49:58",
            "tags":"|grebe|blogging|",
            "post_status":"o",
            "post_digest":"gLeraLqPjeuJXIgFEicPkg",
            "formatted_created_time":"11:49:58 AM",
            "title":"new UPDATED post text 2014-06-25 16:49:59",
            "formatted_created_date":"Jun 25, 2014",
            "uri_title":"new-updated-post-text-20140625-16-49-59"
        },
        "status":200,
        "version_data":
        {
            "right_uri_title":"new-updated-post-text-20140625-16-49-59",
            "right_time":"11:49:59 am",
            "right_title":"new UPDATED post text 2014-06-25 16:49:59",
            "left_version":"1",
            "right_post_id":"121",
            "right_version":"2",
            "right_date":"Jun 25, 2014",
            "left_parent_id":"121",
            "left_post_id":"122",
            "right_parent_id":"0",
            "left_uri_title":"20140625-16-49-58-this-will-be-the-post-title",
            "left_time":"11:49:58 am",
            "left_title":"2014-06-25 16:49:58 this will be the post title",
            "left_date":"Jun 25, 2014"
        },
        "description":"OK",
        "compare_results": [
            {
                "left":"# 2014-06-25 16:49:58 this will be the post title",
                "rightdiffclass":"changed",
                "modindicator":"c",
                "leftdiffclass":"changed",
                "right":"# new UPDATED post text 2014-06-25 16:49:59"
            },
            {
                "left":"",
                "rightdiffclass":"unmodified",
                "modindicator":"u",
                "leftdiffclass":"unmodified",
                "right":""
            },
            {
                "left":"here is the start of the body text",
                "rightdiffclass":"unmodified",
                "modindicator":"-",
                "leftdiffclass":"removed",
                "right":""
            },
            {
                "left":"",
                "rightdiffclass":"unmodified",
                "modindicator":"-",
                "leftdiffclass":"removed",
                "right":""
            },
            {
                "left":"here is some more text.",
                "rightdiffclass":"unmodified",
                "modindicator":"u",
                "leftdiffclass":"unmodified",
                "right":"here is some more text."
            },
            {
                "left":"",
                "rightdiffclass":"unmodified",
                "modindicator":"u",
                "leftdiffclass":"unmodified",
                "right":""
            },
            {
                "left":"testin **markdown bolding**",
                "rightdiffclass":"changed",
                "modindicator":"c",
                "leftdiffclass":"changed",
                "right":"tags #grebe #blogging"
            },
            {
                "left":"",
                "rightdiffclass":"unmodified",
                "modindicator":"-",
                "leftdiffclass":"removed",
                "right":""
            },
            {
                "left":"hashtag #test #perl",
                "rightdiffclass":"unmodified",
                "modindicator":"-",
                "leftdiffclass":"removed",
                "right":""
            }
        ]
    }


## Deleted or Undeleted a post.
    {
        "status":200,
        "description":"OK"
    }




## Get post for user who is not the author.

    {
        "status"                   :  200,
        "description"              :  "OK",
        "parent_id"                :  "0",
        "post_id"                  :  "9",
        "title"                    :  "2014-05-02 15:13:57 this will be the title",
        "uri_title"                :  "20140502-15-13-57-this-will-be-the-title",
        "formatted_text"           :  "<p>here is the start of the body text</p>\n\n<p>here is some more text.</p>\n\n<p>testin <strong>markdown bolding</strong></p>\n\n<p>hashtag <a href=\"/tag/test\">#test</a> <a href=\"/tag/perl\">#perl</a></p>\n",
        "author_name"              : "testuser1398830044",
        "created_date"             :  "2014-05-02 15:13:58",
        "modified_date"            :  "2014-05-02 15:13:58",
        "formatted_created_date"   :  "May 02, 2014"
        "formatted_modified_date"  :  "May 02, 2014",
        "reader_is_author"         :  0,
        "post_status"              :  "o",
        "post_type"                :  "a",
        "related_posts_count"      :  2,
        "version"                  :  "1",
        "tags"                     :  "|test|perl|",
    }



### Stream of posts.

    {
        "logged_in_user_id":0,
        "filter_by_author_name":null,
        "status":200,
        "description":"OK",
        "next_link_bool":0,
        "posts": [
            {
                "tag_link_str":"<a href=\"/tag/fishing\">#fishing</a>  <a href=\"/tag/portage\">#portage</a>  <a href=\"/tag/river\">#river</a>",
                "modified_date":"2014-07-18 14:08:33",
                "formatted_text":"<p><small>(my Monday, November 18, 2002 blog post)</small></p>\n\n<p>I fished for about 90 minutes around midday in the same pool of the Portage river I was at a couple Saturdays ago, except there was no action today. Last time, I had a lot of tugs and slashes at my plastic worms, which kept me alert and encouraged. Today, there was none of that. I fished the Tifa Body Shad. It was sunny with air temps in the mid 30's.</p>\n\n<p><a href=\"/tag/fishing\">#fishing</a> - <a href=\"/tag/portage\">#portage</a> - <a href=\"/tag/river\">#river</a></p>\n\n",
                "tags_exist":1,
                "user_name":"JR",
                "reader_is_author":0,
                "readingtime":0,
                "post_id":"118",
                "post_type":
                "article",
                "title":"Struckout on smallies in the Portage River",
                "uri_title":"struckout-on-smallies-in-the-portage-river",
                "formatted_date":"Jul 18, 2014"
            },
            {
                "tag_link_str":"<a href=\"/tag/fishing\">#fishing</a>  <a href=\"/tag/river\">#river</a>  <a href=\"/tag/portage\">#portage</a>",
                "modified_date":"2014-07-08 23:57:45",
                "formatted_text":"<p><small>(my Tuesday, November 12, 2002 blog post)</small></p>\n\n<p>This past Saturday afternoon (09-Nov-2002), I fished the Portage river between Elmore and Woodville. I waded a pool that was about 50 yards long. Since the rivers and streams in the area have been at late summer levels due to little rainfall in recent weeks, and since the temperatures were in the 60's, I decided to see if I could catch some Smallmouth bass. </p>\n\n",
                "tags_exist":1,
                "more_text_exists":1,
                "user_name":"John",
                "reader_is_author":0,
                "readingtime":0,
                "post_type":"article",
                "post_id":"94",
                "title":"Fishing the Portage river",
                "uri_title":"fishing-the-portage-river",
                "formatted_date":"Jul 08, 2014"
            }
        ]
    }


## Tag list by sorted by count

    {
        "total_unique_tags":20,
        "sort_by":"count",
        "tag_list": [
            {"tag_count":"10","tag_name":"test"},
            {"tag_count":"10","tag_name":"perl"},
            {"tag_count":"9","tag_name":"home"},
            {"tag_count":"8","tag_name":"beer"},
            {"tag_count":"7","tag_name":"beverage"},
            {"tag_count":"5","tag_name":"recipe"},
            {"tag_count":"3","tag_name":"food"},
            {"tag_count":"2","tag_name":"todo"},
            {"tag_count":"2","tag_name":"flower"},
            {"tag_count":"2","tag_name":"garden"},
            {"tag_count":"2","tag_name":"nature"},
            {"tag_count":"2","tag_name":"toledo"},
            {"tag_count":"1","tag_name":"insect"},
            {"tag_count":"1","tag_name":"environment"},
            {"tag_count":"1","tag_name":"tag2"},
            {"tag_count":"1","tag_name":"blogging"},
            {"tag_count":"1","tag_name":"business"},
            {"tag_count":"1","tag_name":"bread"},
            {"tag_count":"1","tag_name":"tag1"},
            {"tag_count":"1","tag_name":"grebe"}
        ],
        "status":200,
        "description":"OK"
    }


## Tag list sorted by name.

    {
        "total_unique_tags":20,
        "sort_by":"name",
        "tag_list":[
            {"tag_count":"8","tag_name":"beer"},
            {"tag_count":"7","tag_name":"beverage"},
            {"tag_count":"1","tag_name":"blogging"},
            {"tag_count":"1","tag_name":"bread"},
            {"tag_count":"1","tag_name":"business"},
            {"tag_count":"1","tag_name":"environment"},
            {"tag_count":"2","tag_name":"flower"},
            {"tag_count":"3","tag_name":"food"},
            {"tag_count":"2","tag_name":"garden"},
            {"tag_count":"1","tag_name":"grebe"},
            {"tag_count":"9","tag_name":"home"},
            {"tag_count":"1","tag_name":"insect"},
            {"tag_count":"2","tag_name":"nature"},
            {"tag_count":"10","tag_name":"perl"},
            {"tag_count":"5","tag_name":"recipe"},
            {"tag_count":"1","tag_name":"tag1"},
            {"tag_count":"1","tag_name":"tag2"},
            {"tag_count":"10","tag_name":"test"},
            {"tag_count":"2","tag_name":"todo"},
            {"tag_count":"2","tag_name":"toledo"}
        ],
        "status":200,
        "description":"OK"
    }


