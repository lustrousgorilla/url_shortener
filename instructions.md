We'd like you to create a URL shortening service, similar to [bit.ly](https://bitly.com). This exercise has multiple deliverables:
1. Stand up the basic URL shortening service
2. Implement redirecting shortened links to their original long URLs
3. Implement unique shortened URLs for users
4. Implement analytics (optional)

You should spend around 3 hours on this, no more. Err on the side of completeness of individual features, over completing all features. You can use any language and tools you'd like. Thanks in advance for taking the time do do this exercise!

Your submission should include the following:
- the source code
- steps to setup, initialize and run the application
- anything else you think is helpful for us to test things out

You can submit a zip, a tarball, or github repo.

## Part 1: Create a URL shortener service

Ok, let's say we want to create a simple link shortening service, something that creates shortened links for the URLs sent to it. Here's an example request to your service:
```
POST http://localhost:8080/short_link
{
  "long_url": "<long_url>"
}
```
Your API should accept a `POST` request with a JSON body and a content-type of `application/json`. The `long_url` should be a valid URL like `https://kapost.com`.

If the `long_url` has already been shortened, you should return the previously created `short_link`. Otherwise, you should return a new `short_link`.  The response should look something like 
```
{
  "long_url": "<long_url>",
  "short_link": "<short_link>"
}
```
where the `short_link` looks something like `http://localhost:8080/a1B2c3D4`

## Part 2: Redirect shortened links to their original long URLs

All right, great. We have a link shortening service! It'd be nice to be able to redirect users using these short links. Go ahead and add functionality to your service to redirect from short links to their original long URLs. A request to your service would look something like:
```
GET http://localhost:8080/a1B2c3D4
```
which would return a 301 that redirects the user to the original URL.

## Part 3: Make Short Links Unique to a User

Nice, we've got a service that shortens links and redirects to their original URLS. However, if different users shorten the same long URL, they're going to want different short links than each other. Let's update the shortening feature to take a `user_id`:
```
POST http://localhost:8080/short_link
{
  "long_url": "<long_url>",
  "user_id": "<user_id>"
}
```
Creating multiple short links with the same `long_url` and different `user_id` values should return different short links. Similar to Part 1, repeating a request with the same `long_url` and `user_id` should return the same short link.

## Part 4: Implement analytics (optional)
If you have time, you could create an analytics view for a given short link that will show analytics about each time the short link has been accessed. The analytics view is enabled by adding a `+` to the end of a short link. For example
```
GET http://localhost:8080/a1B2c3D4+
{
  "response": [
    { 
      "time": "2018-10-01T10:00:00Z", 
      "referrer": "none", 
      "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36" 
    },
    { 
      "time": "2018-10-01T15:30:10Z", 
      "referrer": "none", 
      "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36" 
    }
  ]
}
```
In the above example, the `referrer` is `none` because the link was directly pasted into a browser.  It should follow the same semantics of the HTTP referrer header.
