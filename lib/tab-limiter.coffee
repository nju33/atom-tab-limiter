{CompositeDisposable} = require 'atom'

module.exports =
  config:
    'upperLimit':
      title: 'Tab upper limit'
      type: 'number'
      default: 10

  activate: (state) ->
    @subscription = new CompositeDisposable()

    @subscription.add atom.workspace.onDidAddPaneItem ({item, pane, index}) =>
      upperLimit = atom.config.get 'tab-limiter.upperLimit'
      return if index < upperLimit

      for item, idx in pane.items
        if item.isModified() or @containsPinnedClassOnAssociatedTab item, idx
          continue

        pane.destroyItem item
        break

  deactivate: ->
    @subscription.dispose()

  containsPinnedClassOnAssociatedTab: (item, idx) ->
    itemView = atom.views.getView item
    if itemView.parentElement?.previousElementSibling?
      tab = itemView.parentElement?.previousElementSibling?.children[idx]
      return tab.classList.contains 'pinned'
    false
