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
        return true unless 'isModified' in item
        not (item.isModified() or @containsPinnedClassOnAssociatedTab item, idx)
      length = filterdItems.length

      return if length < upperLimit

      for item, idx in filterdItems
        pane.destroyItem item
        length--
        break if length <= upperLimit

  deactivate: ->
    @subscription.dispose()

  containsPinnedClassOnAssociatedTab: (item, idx) ->
    itemView = atom.views.getView item
    if itemView?.parentElement?.previousElementSibling?
      tab = itemView.parentElement.previousElementSibling.children[idx]
      return tab.classList.contains 'pinned'
    false
