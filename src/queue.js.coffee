# Queue.js
#
# @description An javascript queue
# @author Gabriel Corado <gabrielcoradod@mail.com>
# @version 0.0.0

# Queue action
class QueueAction
  # Instance methods

  # Constructor
  constructor: (@name, @fn, @options) ->
    # Set default values
    @reset()

  # Set default values
  reset: ->
    @performed = false
    @active = false
    @retries = 0
    @error = false

  # Perform the action
  _perform: (params = [  ], fn) =>
    # Set the action as active
    @active = true

    # Set fn
    @_fnCallback = fn

    # Run the action
    @fn.apply null, params.concat @result

    # Default return
    return true

  # Result method
  result: (err = null, params...) =>
    # Set as no active action
    @active = false

    if err?
      # Set error
      @error = true
    else
      # Reset error
      @error = false

      # Checks error
      @performed = true

    # Call fn if exists
    @_fnCallback.apply null, [err].concat params if @_fnCallback?

    # Default return
    return true

# Base class
#
class Queue
  # Instance methods

  # Constructor
  constructor: (@options = {  }) ->
    # Init an empty queue
    @_queue = {  }

    # Set the default performer (async or sync)
    @options.performer ||= 'async'

  # Return the elegibles actions in array format
  _elegibleQueueActionsArr: ->
    # Actions
    actions = [  ]

    # Each all the actions
    for name, action of @_queue
      # Checks if active or performed
      unless action.active || action.performed
        actions.push action

    # Return actions
    return actions

  # Has the action
  hasAction: (name) ->
    return @_queue[name]?

  # Add action to queue
  add: (name, fn, options = {  }) ->
    # Checks the action exists
    return false if @hasAction(name)

    # Set to the queue
    @_queue[name] = new QueueAction(name, fn, options, this)

    # Default return
    return true

  # Remove action from queue
  remove: (name) ->
    # Checks action exists
    return false unless @hasAction(name)

    # Remove from queue
    delete @_queue[name]

    # Default return
    return true

  # Return the action
  action: (name) ->
    # Checks action exists
    return false unless @hasAction(name)

    # Return the action
    return @_queue[name]

  resetAction: (action) ->
    # Checks action exists
    return false unless @hasAction(name)

    # Reset
    @_queue[name].reset()

    # Default return
    return true

  # Any active
  anyActive: ->
    # Set default result
    result = false

    # Each all the actions
    for name, action of @_queue
      # Checks active
      if action.active
        result = true
        break

    # Return the result
    return result

  # Any Error
  anyError: ->
    # Set default result
    result = false

    # Each all the actions
    for name, action of @_queue
      # Checks error
      if action.error
        result = true
        break

    # Return the result
    return result

  # Perform the queue
  perform: (cb) ->
    # Set the name
    performerName = '_performer_' + @options.performer

    # Checks performer exists
    return false if typeof this[performerName] != 'function'

    # Perform it
    this[performerName].call this, cb

    # Default return
    return true

  # Async
  _performer_async: ->
    # Each all the actions
    for name, action of @_queue
      # Checks if active or performed
      unless action.active || action.performed
        # Perform the action
        action._perform [  ]

  # Sync
  _performer_sync: (cb) ->
    # Actions
    actions = @_elegibleQueueActionsArr()

    # Recursive perform
    recursivePerform = (currentIndex, performParams) ->
      # Perform the action
      actions[currentIndex]._perform performParams, (err, actionResults...) =>
        # Next index
        nextIndex = currentIndex + 1

        # Last index
        lastIndex = actions.length - 1

        # Checks error
        if !err?
          # Checks has next action
          if nextIndex < lastIndex
            # Call the next action
            recursivePerform nextIndex, actionResults
          else
            # Last
            actions[nextIndex]._perform actionResults, (err, actionResults...) =>
              # Callback
              cb.apply null, [err].concat actionResults if cb?

    # Start the recursive
    recursivePerform 0, [  ]

# Set the queue
window.Queue = Queue
