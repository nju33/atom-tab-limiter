describe "Tab limiter", ->
  beforeEach ->
    atom.config.set 'tab-limiter.upperLimit', 3

  it "Get config", ->
    upperLimit = atom.config.get 'tab-limiter.upperLimit'
    expect(upperLimit).toBe(3)

  it "Exceed the upper limit", ->
    promises = [
      atom.workspace.open()
      atom.workspace.open()
      atom.workspace.open()
      atom.workspace.open()
    ]

    waitsForPromise ->
      Promise.all promises
      .then ->
        setTimeout ->
          pane = atom.workspace.getActivePane()
          expect(pane.items.length).toBe(3)
        , 0

  it "Includes modified tab", ->
    waitsForPromise ->
      atom.workspace.open().then (textEditor) ->
        textEditor.setText 'test'

        promises = [
          atom.workspace.open()
          atom.workspace.open()
          atom.workspace.open()
        ]
        Promise.all promises
        .then ->
          setTimeout ->
            pane = atom.workspace.getActivePane()
            expect(pane.items.length).toBe(4)
            expect(pane.items[0].getText()).toBe('test')
          , 0
