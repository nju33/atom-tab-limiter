{CompositeDisposable} = require 'atom'

module.exports =
  config:
    'upperLimit':
      title: 'Tab upper limit'
      type: 'number'
      default: 10

  activate: (state) ->
    @subscription = new CompositeDisposable()

    @subscription.add atom.workspace.onDidAddPaneItem ({item, pane}) =>
      upperLimit = atom.config.get 'tab-limiter.upperLimit'
      size = pane.items.length
      filterdItems = pane.items.filter (item, idx) =>
        return true if item.uri is 'atom://config'
        return false if item.isModified? and item.isModified()
        true
      length = filterdItems.length

      return if length < upperLimit

      for item, idx in filterdItems
        # Settings page
        if item.uri is 'atom://config'
          pane.destroyItem item
          length--
          return

        filename = item.getFileName()
        filepath = item.getPath()

        pane.destroyItem item
        length--

        return unless filepath
        atom.notifications.addInfo "Closed '#{filename}'",
          description: filepath
          buttons: [
            {
              text: 'Reopen'
              onDidClick: ->
                if filepath
                  atom.workspace.open filepath
            }
          ]

        break if length <= upperLimit

  deactivate: ->
    @subscription.dispose()

  # containsPinnedClassOnAssociatedTab: (item, idx) ->
  #   itemView = atom.views.getView item
  #   if itemView?.parentElement?.previousElementSibling?
  #     tab = itemView.parentElement.previousElementSibling.children[idx]
  #     tab.classList?.contains 'pinned'
  #   false
