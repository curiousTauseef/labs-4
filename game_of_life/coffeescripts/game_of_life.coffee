class GameOfLife
  currentCellGeneration: null
  cellSize: 20
  numberOfRows: 100
  numberOfColumns: 100
  seedProbability: 0.5
  tickLength: 100
  canvas: null
  drawingContext: null
  currentPopulation = 0

  constructor: ->
    @createCanvas()
    @resizeCanvas()
    @createDrawingContext()

    @seed()

    @tick()

  createCanvas: ->
    @canvas = document.createElement 'canvas'
    document.body.appendChild @canvas

  resizeCanvas: ->
    @canvas.height = document.body.clientHeight*0.8
    @canvas.width = document.body.clientWidth*0.8

  createDrawingContext: ->
    @drawingContext = @canvas.getContext '2d'

  seed: ->
    @currentCellGeneration = []

    for row in [0...@numberOfRows]
      @currentCellGeneration[row] = []

      for column in [0...@numberOfColumns]
        seedCell = @createSeedCell row, column
        @currentCellGeneration[row][column] = seedCell

  createSeedCell: (row, column) ->
    isAlive: Math.random() < @seedProbability
    row: row
    column: column

  drawGrid: ->
    for row in [0...@numberOfRows]
      for column in [0...@numberOfColumns]
        @drawCell @currentCellGeneration[row][column]

  drawCell: (cell) ->
    x = cell.column * @cellSize
    y = cell.row * @cellSize

    if cell.isAlive
      fillStyle = 'rgb(242, 198, 65)'
    else
      fillStyle = 'rgb(38, 38, 38)'

    @drawingContext.strokeStyle = 'green'
    @drawingContext.strokeRect x, y, @cellSize, @cellSize

    @drawingContext.fillStyle = fillStyle
    @drawingContext.fillRect x, y, @cellSize, @cellSize

  tick: =>
    @drawGrid()
    @evolveCellGeneration()

    setTimeout @tick, @tickLength

  evolveCellGeneration: ->
    newCellGeneration = []

    for row in [0...@numberOfRows]
      newCellGeneration[row] = []

      for column in [0...@numberOfColumns]
        evolvedCell = @evolveCell @currentCellGeneration[row][column]
        newCellGeneration[row][column] = evolvedCell

    @currentCellGeneration = newCellGeneration

  evolveCell: (cell) ->
    evolvedCell =
      row: cell.row
      column: cell.column
      isAlive: cell.isAlive

    numberOfAliveNeighbors = @countAliveNeighbors cell

    if cell.isAlive or numberOfAliveNeighbors is 3
      evolvedCell.isAlive = 1 < numberOfAliveNeighbors < 4

    evolvedCell

  countAliveNeighbors: (cell) ->
    lowerRowBound = Math.max cell.row - 1, 0
    upperRowBound = Math.min cell.row + 1, @numberOfRows - 1
    lowerColumnBound = Math.max cell.column - 1, 0
    upperColumnBound = Math.min cell.column + 1, @numberOfColumns - 1
    numberOfAliveNeighbors = 0

    for row in [lowerRowBound..upperRowBound]
      for column in [lowerColumnBound..upperColumnBound]
        continue if row is cell.row and column is cell.column

        if @currentCellGeneration[row][column].isAlive
          numberOfAliveNeighbors++

    numberOfAliveNeighbors
    
    
   
  getCurrentPopulation: (@currentCellGeneration)->
    for row in [0...@numberOfRows]
      for column in [0...@numberOfColumns]
         @currentPopulation++ if @currentCellGeneration[row][column].isAlive
   

window.GameOfLife = GameOfLife