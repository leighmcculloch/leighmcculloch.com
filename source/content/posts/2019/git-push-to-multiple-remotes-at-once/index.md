+++
slug = "git-push-to-multiple-remotes-at-once"
title = "Git: Push to multiple remotes at once"
date = 2019-07-04
+++

Git lets you push to multiple remotes at once by setting multiple URLs for a remote. This is will allow you to push to many remotes with a single `git push`. I find this convenient when I need to frequently push to a mirror since it is easier than doing two git pushes everytime.

To setup pushing to multiple remotes with a single `git push`:

1. Clone your repository, or create one fresh and configure it how you would with a single remote as origin.
   ```
   git remote add origin git@github.com:[username]/[repository]
   ```

2. Set the multiple remote URLs including the one you already set above.
   ```
   git remote set-url --add --push origin git@github.com:[username]/[repository]
   git remote set-url --add --push origin git@bitbucket.org:[username]/[repository]
   ```

To confirm the remote URLs are configured correctly:
```
git remote -v
```
You should see something like this:
```
origin	git@github.com:[username]/[repository] (fetch)
origin	git@github.com:[username]/[repository] (push)
origin	git@bitbucket.org:[username]/[repository] (push)
```

From here on a `git fetch` or `git pull` will fetch from the first URL in that list, and a `git push` will push to all push URLs.

This can be a great feature to use if you've got a repository mirrored on [GitHub](https://github.com) and [BitBucket](https://bitbucket.org), or if you're using [AWS CodeCommit](https://aws.amazon.com/codecommit/) and want to mirror the repository across multiple regions.
