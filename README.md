# Queue.js

It's like a group of actions that can be performed the way you want (defaults is sync and async). Just define the queue and the actions and perform it. First it'll **only run in browsers**.

## Table of contents

* [How to use](#how-to-use)
* [Checklist](#checklist)
* [API](#api)

## How to use

First, add the queue script on your page

```html
<script type="text/javascript" src="queue.js"></script>
```

after that, define your queue, the queue initializer accepts an object of options

```javascript
var timeQueue = new Queue({ performer: 'sync' });
```

and then set your actions

```javascript
// First action
timeQueue.add('firstAction', function(callback) {
  console.log('firstAction - Started', new Date());

  setTimeout((function(){
    return function() {
      console.log('firstAction - Ended', new Date());
      callback(null, 'Hey secondAction');
    }
  }).call(this), 5000);
} );
```

all the actions have an argument called **callback**, you should to call it because that's how the next action will be called in **sync performer**. In this argument you can pass arguments for the next action or an error that'll stop the queue.

```javascript
// Second action
timeQueue.add('secondAction', function(msg, callback) {
  console.log('firstActions says: ' + msg);
  console.log('secondAction - Started - Ended', new Date());
  callback();
} );
```

after define the actions you can perform all of them

```javascript
// Perform
timeQueue.perform();
```

using the **sync performer** you can pass a callback that'll be called when all the actions has been performed, and the last action pass some arguments too.

```javascript
// Last action
timeQueue.add('lastAction', function(callback) {
  console.log('lastAction - Started - Ended', new Date());
  callback(null, 'That\'s all folks.');
} );

// Perform
timeQueue.perform(function(err, msg){
  console.log('lastAction says: ' + msg);
  console.log('All the actions has been performed.');
});
```

## Checklist

<input type="checkbox" disabled="disabled" checked="checked" />
*~~Basic Queue~~*

<input type="checkbox" disabled="disabled" checked="checked" />
*~~QueueAction~~*

<input type="checkbox" disabled="disabled" checked="checked" />
*~~Sync and Async performers~~*

<input type="checkbox" disabled="disabled" checked="checked" />
*~~Custom performer~~*

<input type="checkbox" disabled="disabled" />
Async perform callback

<input type="checkbox" disabled="disabled" />
Better perform callback results

<input type="checkbox" disabled="disabled" />
More Examples

<input type="checkbox" disabled="disabled" />
Retries

<input type="checkbox" disabled="disabled" />
Queue action history

## API

### new Queue(options)

Create new queue with options.

### Queue.hasAction(name)

Checks if the action exists.

### Queue.add(name, fn, options)

Add action to queue.

### Queue.remove(name)

Remove action from queue.

### Queue.action(name)

Return the queue action.

### Queue.resetAction(name)

Reset the action, if you reset an action you can perform it again.

### Queue.anyActive()

Checks any action active.

### Queue.anyError()

Checks any action with error.

### Queue.perform(cb)

Perform the actions and call the cb function when all of them has been performed.
