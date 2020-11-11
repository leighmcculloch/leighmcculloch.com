+++
slug = "filtering-github-notifications-in-gmail"
title = "Filtering GitHub Notifications in Gmail"
date = 2020-11-04
+++

GitHub sends notifications about _everything_. This is great, but also noisy. The good news is we can wrangle it with a few filters. The filters below are geared for Gmail and make use of Gmail's Important feature, where important mail is flagged and grouped separately when Gmail is configured with the `Priority Inbox` inbox type.

Notifications that are important to us, such as review requests, mentions, and comments on issues we are involved in, will be flagged as important. Notifications that are the result of us being subscribed to a repository will still end up in the inbox but not marked important. Notifications like commits on pull requests will skip the inbox entirely but won't be marked as read so that the next time a comment is posted to that pull request we'll see all the pushes unfurled in the thread.

The filters use a set of `CC` email addresses that GitHub defines [here](https://docs.github.com/en/free-pro-team@latest/github/managing-subscriptions-and-notifications-on-github/configuring-notifications#filtering-email-notifications).

```
Matches: from:(notifications@github.com)
Do this: Apply label "GitHub"
```

```
Matches: (cc:author@noreply.github.com OR cc:manual@noreply.github.com OR cc:mention@noreply.github.com OR cc:team_mention@noreply.github.com OR cc:assign@noreply.github.com OR cc:state_change@noreply.github.com OR cc:security_alert@noreply.github.com)
Do this: Mark it as important
```

```
Matches: cc:review_requested@noreply.github.com "requested your review"
Do this: Apply label "RR/Me", Mark it as important
```

```
Matches: cc:review_requested@noreply.github.com "requested review from"
Do this: Apply label "RR/Team", Mark it as important
```

```
Matches: cc:subscribed@noreply.github.com
Do this: Never mark it as important
```

```
Matches: cc:push@noreply.github.com
Do this: Skip Inbox, Never mark it as important
```

GitHub also has an optional feature that makes this even better. We can configure GitHub to send notification emails for our own activity. If we enable this feature we get a complete history of issues and pull requests in our email client. The following filter marks our activity notifications as read and archived so that we don't see them in our inbox and only when viewing threads. It also marks the notification as important so that the thread as a whole is marked as important.

```
Matches: cc:your_activity@noreply.github.com
Do this: Skip Inbox, Mark as read, Mark it as important
```

These notifications are enabled in [GitHub's Notification settings](https://github.com/settings/notifications).

![](screenshot-enable-your-activity.png)

With all the above filters enabled our filter settings in Gmail should look like this:

![](screenshot-filters.png)
