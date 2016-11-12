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

      for item in pane.items
        if item.isModified()
          continue

        pane.destroyItem item
        break

  deactivate: ->
    @subscription.dispose()
