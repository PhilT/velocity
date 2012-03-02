Velocity - Simple Release Management
====================================

Status
--------------------
**Beta**
Velocity has been on hold for a few months but I'm hoping to do some more work on it shortly with an improved interface, Rails 3 support and some easy deployment options. (October 2010)


What is Velocity?
--------------------
**Todo on steroids!**

Velocity extends the to-do list concept with a few extra features to make it useful to manage small projects
with a handful of people. It tries to keep it simple with a clear single page main interface. It comes from
starting with tadalist.com but quickly running into issues managing large lists with state.

Usage
-------------------
Velocity is a Rails 2.3.5 application. MySQL is the default database.

Users can be added by other users. If no users are in the database Velocity allows the first one to be added without logging in.

Features
--------------

* Inline editing of task details
* Drag to re-order tasks
* Current and future releases
* Simple state transitions (move to current release, start, complete, verify)
* Simple categories: feature, bug, refactor
* Details view: Shows started/completed and verifier
* Groups - highlight related tasks
* Mark a release as complete - emails all users a feature and bug list. Fails if tasks have not been verified. Does not include any tasks that are incomplete
* View tasks in previous releases
* Embed links in task descriptions
* Show velocity for previous releases (Velocity is very simply the number of tasks completed)
* Live updates - Users are notified when new tasks are created, a task is assigned to them or tasks are reordered or a release is finished. If details or state of a task has changed then the task is simply updated inline without notification.
* Mark a task invalid. Gets included when a release is completed

Planned
--------------
* Fix bugs and ideas that didn't work
* Upgrade to Rails 3
* UI redesign (again). Just want to clean it up and make it responsive
* Stats page
* Multi-project support

