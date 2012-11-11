EventEmitter = require('events').EventEmitter

class Team extends EventEmitter

    constructor: (@id, @teamSize = 1) ->
        @periods = []
        @period = 0
        @interval = 1
        @trackCount = 5
        @persons = []
        @surge = 0
    
    start: () ->
        @isStarted = true
        @setRowInterval @interval

    setRowInterval: (interval) ->
        @interval = interval
        newInterval = 1000 * @interval

        @rowInterval = setInterval () =>
            @emit 'coach', @, @interval
            @evaluateRows()
            @startNewPeriod(++@period % @trackCount)
        , newInterval 

        @emit 'interval', newInterval
        
    startNewPeriod: (position) ->
        @periods[position] = 
            people: {}
            success: false

    getCurrentPeriod: () ->
        @periods[@period % @trackCount] ||= {}
        
    evaluateRows: () ->
        current = @getCurrentPeriod()
        goodRows = 0

        #did every person have exactly 1 row in this period?
        screwUps = []
        for k,v of current.people
            if v is 1
                goodRows++ 
            else 
                screwUps.push k

        #did atleast 80% of people successfuly row?
        rowPercentage = goodRows / @persons.length

        if rowPercentage > .8
            current.success = true
            @emit 'surge', @,
                accuracy: rowPercentage
                period: @period
                mph: @interval / 10
                surge: ++@surge * 10
                screwUps: screwUps
    
    broDown: (person) ->

    row: (person) ->
        if not @isStarted then return

        currentPeriod = @getCurrentPeriod()
        currentPeriod.people[person.socketId] ||= 0 
        currentPeriod.people[person.socketId]++
    
    disband: () ->
        @isStarted = false
        @removeAllListeners()
        clearInterval @rowInterval if @rowInterval
        
    addPerson: (person) ->
        full = @isFull() 
        return false if full
        @persons.push person
        @emit 'full' if @isFull()  
        return true

    isFull: () ->
        @persons.length == @teamSize
    
module.exports = Team