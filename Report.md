# Bugfixing report


1. Analysis of issue message

  ```
    "I am trying to find a contact in my database, but the app is not working. When I try to open the contact list it says "We're sorry, but something went wrong (500)".
  ```

	1.1 Detecting bug's status
      Relying on customer's report, we got internal server error(500). In diverse from 'not found record' or 'wrong path', it's a critical error, which prevent client from working with app. So, it need to be solved in the first place, other trivial or minor tasks can be postponed for a while.

2. Searching for a cause

	2.1 As only we've decided to work with task immediately, we need to figure out the exact line of code which creates a bug.

	2.2 Ideally, there is bugsnag or other error reporting system, so we would have got an email and started working on a problem while client was only writing his report. Bugsnag provides cosy interface with whole information about trapped server error, request data and involved user.
	    Another way – searching into production logs. Or trying to reproduce error with customer data.

	2.3 Client got an error in production mode, so we need to be sure, that we are up-to-date with all newest changes. Pull request from master will help us.
	    In our case(due to proposed fixtures) we got error line

      ```
        Showing /home/anton/projects/satoriapp_coding_challenge/coding_challenge-narmina/app/views/contacts/index.html.haml where line #73 raised:
        No route matches {:action=>"tag", :controller=>"contacts", :format=>nil, :tag=>"1/1 coaching"} missing required keys: [:tag]
      ```

	2.4 So, line was detected, what is the error's cause?
	    Mentioned in a trace line file gives us

        %li.label.label-default= link_to t.name, contacts_tag_path(t.name)

      Obviously, error happened in creating path in routes helper. Check in rails console using tag name from error text gives us the same message.
      Or we can use pry-bug to a breakpoint and detect for example tag id, which creates an error.

      ```
        app.contacts_tag_path("1/1 coaching")
      ```

      The culprit here is name "1/1 coaching". What's unusual in it? Wright, slash. We try to create url with slash in params.
      So what? Why it happens now, in creation, not when we use url link directly? Need to go to routes to see.

3. Refactoring our code.

	3.1 Creating new branch
      At first we have to checkout into another branch for bugfixsing.

	3.2 Fix path
	    In routes we see restriction for tags path

      ```
        get "/tags/:tag", action: :tag, as: :tag, constraints: { tag: /[^\/]+/ }
      ```

      Who decided not allow slash in tags? Git blame will say us.. Probably, he did it for purpose..
      Removing constrains gives us ability to see contact list(finally). But what about link to particular tag? If it works with extra slash?

	3.3 Checking side effects and running tests
      Clicking url contacts/tags/1/1%20coaching gives us another one error

      ```
        No route matches [GET] "/contacts/tags/1/1%20coaching"

      ```
      And rake routes only confirms it:

        contacts_tag GET    /contacts/tags/:tag(.:format)       contacts#tag

      There is no an appropriate path in routes, which could have caught our url.

	3.4 Final refactoring
      Solution? We need asterisk in the pattern to match for everything after it, to absorb whole tail after last meaningful slash.

      ```
        get "/tags/*tag", action: :tag, as: :tag
      ```

4. Committing results

  Includes commit for new branch and pull request into master. If we have enough rights - deploy to production.
  If we have ci system, it will run tests during build process. But better to run them locally too, especially for big changes.

5. Reporting about results.

   Using issue tracking product is good to describe problems cause and solution, estimate spent time, close the task and automatically inform support team,
   which gives ability to notify customer about solved issue.


## Questions

  * How can you identify the cause of the bug? - error tracking system, logs, impersonation with user data

  * What is the culprit? - slash in params in routes

  * What approach might you take to fixing it? - googling for the similar problem, code refactoring, tests checking
