* Project setup - Haml, Sass, Sprockets, Bundler, Rakefile, DataMapper, SQLite, testing
* Prototype main screen
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
* Stats page
* Multi-project support
