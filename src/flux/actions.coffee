Reflux = require 'reflux'

ActionScopeWindow = 'window'
ActionScopeGlobal = 'global'
ActionScopeMainWindow = 'main'

###
Public: In the Flux {Architecture.md}, almost every user action
is translated into an Action object and fired globally. Stores in the app observe
these actions and perform business logic. This loose coupling means that your
packages can observe actions and perform additional logic, or fire actions which
the rest of the app will handle.

In Reflux, each {Action} is an independent object that acts as an event emitter.
You can listen to an Action, or invoke it as a function to fire it.

## Action Scopes

Nylas Mail is a multi-window application. The `scope` of an Action dictates
how it propogates between windows.

- **Global**: These actions can be listened to from any window and fired from any
  window. The action is sent from the originating window to all other windows via
  IPC, so they should be used with care. Firing this action from anywhere will
  cause all listeners in all windows to fire.

- **Main Window**: You can fire these actions in any window. They'll be sent
  to the main window and triggered there.

- **Window**: These actions only trigger listeners in the window they're fired in.

## Firing Actions

```coffee
Actions.postNotification({message: "Archived Thread", type: 'success'})

Actions.queueTask(new MarkThreadReadTask(@_thread))
```

## Listening for Actions

If you're using Reflux to create your own Store, you can use the `listenTo`
convenience method to listen for an Action. If you're creating your own class
that is not a Store, you can still use the `listen` method provided by Reflux:

```coffee
setup: ->
  @unlisten = Actions.didPassivelyReceiveNewModels.listen(@onNewMailReceived, @)

onNewMailReceived: (data) ->
  console.log("You've got mail!", data)

teardown: ->
  @unlisten()
```

Section: General
###
class Actions

  ###
  Public: Fired when the {DatabaseStore} has changed the ID of a {Model}.

  *Scope: Global*
  ###
  @didSwapModel: ActionScopeGlobal

  ###
  Public: Fired when the Nylas API Connector receives new data from the API.

  *Scope: Global*

  Receives an {Object} of {Array}s of {Model}s, for example:

  ```json
  {
    'thread': [<Thread>, <Thread>]
    'contact': [<Contact>]
  }
  ```
  ###
  @didPassivelyReceiveNewModels: ActionScopeGlobal

  ###
  Public: Log out the current user. Closes the main application window and takes
  the user back to the sign-in window.

  *Scope: Global*
  ###
  @logout: ActionScopeGlobal

  @uploadStateChanged: ActionScopeGlobal
  @fileAborted: ActionScopeGlobal
  @downloadStateChanged: ActionScopeGlobal
  @fileUploaded: ActionScopeGlobal
  @multiWindowNotification: ActionScopeGlobal
  @sendDraftSuccess: ActionScopeGlobal
  @sendToAllWindows: ActionScopeGlobal

  ###
  Public: Queue a {Task} object to the {TaskQueue}.

  *Scope: Main Window*
  ###
  @queueTask: ActionScopeMainWindow

  ###
  Public: Dequeue all {Task}s from the {TaskQueue}. Use with care.

  *Scope: Main Window*
  ###
  @dequeueAllTasks: ActionScopeMainWindow
  @dequeueTask: ActionScopeMainWindow

  ###
  Public: Dequeue a {Task} matching the description provided.

  *Scope: Main Window*
  ###
  @dequeueMatchingTask: ActionScopeMainWindow

  @longPollStateChanged: ActionScopeMainWindow
  @longPollReceivedRawDeltas: ActionScopeMainWindow
  @longPollConnected: ActionScopeMainWindow
  @longPollOffline: ActionScopeMainWindow
  @didMakeAPIRequest: ActionScopeMainWindow
  @sendFeedback: ActionScopeMainWindow


  ###
  Public: Show the developer console for the current window.

  *Scope: Window*
  ###
  @showDeveloperConsole: ActionScopeWindow

  ###
  Public: Clear the developer console for the current window.

  *Scope: Window*
  ###
  @clearDeveloperConsole: ActionScopeWindow

  @toggleComponentRegions: ActionScopeWindow

  ###
  Public: Select the provided namespace ID in the current window.

  *Scope: Window*
  ###
  @selectNamespaceId: ActionScopeWindow

  ###
  Public: Select the provided sheet in the current window. This action changes
  the top level sheet.

  *Scope: Window*

  ```
  Actions.selectRootSheet(WorkspaceStore.Sheet.Threads)
  ```
  ###
  @selectRootSheet: ActionScopeWindow

  ###
  Public: Select the desired layout mode.

  *Scope: Window*

  ```
  Actions.selectLayoutMode('list')
  ```
  ###
  @selectLayoutMode: ActionScopeWindow


  ###
  Public: Focus the keyboard on an item in a collection. This action moves the
  `keyboard focus` element in lists and other components,  but does not change
  the focused DOM element.

  *Scope: Window*

  ```
  Actions.selectLayoutMode(collection: 'thread', item: <Thread>)
  ```
  ###
  @focusKeyboardInCollection: ActionScopeWindow

  ###
  Public: Focus on an item in a collection. This action changes the selection
  in lists and other components, but does not change the focused DOM element.

  *Scope: Window*

  ```
  Actions.focusInCollection(collection: 'thread', item: <Thread>)
  ```
  ###
  @focusInCollection: ActionScopeWindow

  ###
  Public: Focus the interface on a specific {Tag}.

  *Scope: Window*

  ```
  Actions.focusTag(<Tag>)
  ```
  ###
  @focusTag: ActionScopeWindow

  ###
  Public: If the message with the provided id is currently beign displayed in the
  thread view, this action toggles whether it's full content or snippet is shown.

  *Scope: Window*

  ```
  message = <Message>
  Actions.toggleMessageIdExpanded(message.id)
  ```
  ###
  @toggleMessageIdExpanded: ActionScopeWindow

  ###
  Public: Create a new reply to the provided threadId and messageId. Note that
  this action does not focus on the thread, so you may not be able to see the new draft
  unless you also call {::focusInCollection}.

  *Scope: Window*

  ```
  # Compose a reply to the last message in the thread
  Actions.composeReply({threadId: '123'})

  # Compose a reply to a specific message in the thread
  Actions.composeReply({threadId: '123', messageId: '123'})
  ```
  ###
  @composeReply: ActionScopeWindow

  ###
  Public: Create a new draft for forwarding the provided threadId and messageId. See
  {::composeReply} for parameters and behavior.

  *Scope: Window*
  ###
  @composeForward: ActionScopeWindow

  ###
  Public: Create a new draft and "reply all" to the provided threadId and messageId. See
  {::composeReply} for parameters and behavior.

  *Scope: Window*
  ###
  @composeReplyAll: ActionScopeWindow

  ###
  Public: Pop out the draft with the provided ID so the user can edit it in another
  window.

  *Scope: Window*

  ```
  messageId = '123'
  Actions.composePopoutDraft(messageId)
  ```
  ###
  @composePopoutDraft: ActionScopeWindow

  ###
  Public: Open a new composer window for creating a new draft from scratch.

  *Scope: Window*

  ```
  Actions.composeNewBlankDraft()
  ```
  ###
  @composeNewBlankDraft: ActionScopeWindow

  ###
  Public: Send the draft with the given ID. This Action is handled by the {DraftStore},
  which finalizes the {DraftChangeSet} and allows {DraftStoreExtension}s to display
  warnings and do post-processing. To change send behavior, you should consider using
  one of these objects rather than listening for the {sendDraft} action.

  *Scope: Window*

  ```
  Actions.sendDraft('123')
  ```
  ###
  @sendDraft: ActionScopeWindow

  ###
  Public: Destroys the draft with the given ID. This Action is handled by the {DraftStore},
  and does not display any confirmation UI.

  *Scope: Window*
  ###
  @destroyDraft: ActionScopeWindow

  ###
  Public: Archive the currently focused {Thread}.

  *Scope: Window*
  ###
  @archive: ActionScopeWindow

  ###
  Public: Archives the Thread objects currently selected in the app's main thread list.

  *Scope: Window*
  ###
  @archiveSelection: ActionScopeWindow
  @archiveAndNext: ActionScopeWindow
  @archiveAndPrevious: ActionScopeWindow
  @toggleStarSelection: ActionScopeWindow

  ###
  Public: Updates the search query in the app's main search bar with the provided query text.

  *Scope: Window*

  ```
  Actions.searchQueryChanged("New Search Query")
  ```
  ###
  @searchQueryChanged: ActionScopeWindow

  ###
  Public: Submits a search with the provided query text. Unlike `searchQueryChanged`, this
  action immediately performs a search.

  *Scope: Window*

  ```
  Actions.searchQueryCommitted("New Search Query")
  ```
  ###
  @searchQueryCommitted: ActionScopeWindow
  @searchWeightsChanged: ActionScopeWindow
  @searchBlurred: ActionScopeWindow

  ###
  Public: Fire to display an in-window notification to the user in the app's standard
  notification interface.

  *Scope: Window*

  ```
  # A simple notification
  Actions.postNotification({message: "Archived Thread", type: 'success'})

  # A sticky notification with actions
  NOTIF_ACTION_YES = 'YES'
  NOTIF_ACTION_NO = 'NO'

  Actions.postNotification
    type: 'info',
    sticky: true
    message: "Thanks for trying out Nylas Mail! Would you like to make it your default mail client?",
    icon: 'fa-inbox',
    actions: [{
      label: 'Yes'
      id: NOTIF_ACTION_YES
    },{
      label: 'Not Now'
      id: NOTIF_ACTION_NO
    }]

  ```
  ###
  @postNotification: ActionScopeWindow

  ###
  Public: Listen to this action to handle user interaction with notifications you
  published via `postNotification`.

  *Scope: Window*

  ```
  @_unlisten = Actions.notificationActionTaken.listen(@_onActionTaken, @)

  _onActionTaken: ({notification, action}) ->
    if action.id is NOTIF_ACTION_YES
      # perform action
  ```
  ###
  @notificationActionTaken: ActionScopeWindow

  # FullContact Sidebar
  @getFullContactDetails: ActionScopeWindow
  @focusContact: ActionScopeWindow

  # Templates
  @insertTemplateId: ActionScopeWindow
  @createTemplate: ActionScopeWindow
  @showTemplates: ActionScopeWindow

  ###
  Public: Remove a file from a draft.

  *Scope: Window*

  ```
  Actions.removeFile
    file: fileObject
    messageLocalId: draftLocalId
  ```
  ###
  @removeFile: ActionScopeWindow

  # File Actions
  # Some file actions only need to be processed in their current window
  @attachFile: ActionScopeWindow
  @attachFilePath: ActionScopeWindow
  @abortUpload: ActionScopeWindow
  @fetchAndOpenFile: ActionScopeWindow
  @fetchAndSaveFile: ActionScopeWindow
  @fetchFile: ActionScopeWindow
  @abortDownload: ActionScopeWindow
  @fileDownloaded: ActionScopeWindow

  ###
  Public: Pop the current sheet off the Sheet stack maintained by the {WorkspaceStore}.
  This action has no effect if the window is currently showing a root sheet.

  *Scope: Window*
  ###
  @popSheet: ActionScopeWindow

  ###
  Public: Push a sheet of a specific type onto the Sheet stack maintained by the
  {WorkspaceStore}. Note that sheets have no state. To show a *specific* thread,
  you should push a Thread sheet and call `focusInCollection` to select the thread.

  *Scope: Window*

  ```
  WorkspaceStore.defineSheet 'Thread', {},
      list: ['MessageList', 'MessageListSidebar']

  ...

  @pushSheet(WorkspaceStore.Sheet.Thread)
  ```
  ###
  @pushSheet: ActionScopeWindow

  @metadataError: ActionScopeWindow
  @metadataCreated: ActionScopeWindow
  @metadataDestroyed: ActionScopeWindow


# Read the actions we declared on the dummy Actions object above
# and translate them into Reflux Actions

# This helper method exists to trick the Donna lexer so it doesn't
# try to understand what we're doing to the Actions object.
create = (obj, name, scope) ->
  obj[name] = Reflux.createAction(name)
  obj[name].scope = scope
  obj[name].sync = true

scopes = {'window': [], 'global': [], 'main': []}

for name in Object.getOwnPropertyNames(Actions)
  continue if name in ['length', 'name', 'arguments', 'caller', 'prototype']
  continue unless Actions[name] in ['window', 'global', 'main']
  scope = Actions[name]
  scopes[scope].push(name)
  create(Actions, name, scope)

Actions.windowActions = scopes['window']
Actions.mainWindowActions = scopes['main']
Actions.globalActions = scopes['global']

module.exports = Actions
