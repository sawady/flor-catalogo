
class ItemService

    @headers = {'Accept': 'application/json', 'Content-Type': 'application/json'}
    @defaultConfig = { headers: @headers }

    constructor: (@$log, @$location, @$http, @$q) ->
        @$log.debug "constructing ItemService"
        
    viewMovies: () ->
        @initializeFor("movies")

    viewGames: () ->
        @initializeFor("games")

    viewMusic: () ->
        @initializeFor("music")

    viewSeries: () ->
        @initializeFor("series")

    viewSoft: () ->
        @initializeFor("soft")
        
    initializeFor: (name) ->
        @ctrlName = name
        
    filterNullProps: (item) ->
       for key, value of item
           # @$log.debug "#{key} and #{value}"
           delete item[key] if not !!value or value.length == 0
           
    hasProp: (item) ->
        for key, value of item
            return true
        return false
        
    createForm: () ->
        @$location.path("/#{@ctrlName}/form")
    
    updateForm: () ->
        @$location.path("/#{@ctrlName}/form")
                
    count: (item) ->
        @$log.debug "count #{@ctrlName}"
        
        deferred = @$q.defer()
        
        @$http.post("/#{@ctrlName}/count", item)
        .success((data, status, headers) =>
                @$log.info("Successfully counted #{@ctrlName} - status #{status}")
                deferred.resolve(data)
            )
        .error((data, status, headers) =>
                @$log.error("Failed to list #{@ctrlName} - status #{status}")
                deferred.reject(data);
            )
        deferred.promise

    list: (item) ->
        @$log.debug "list() #{@ctrlName} like #{angular.toJson(item)}"
        deferred = @$q.defer()
        
        @$http.post("/#{@ctrlName}", item)
        .success((data, status, headers) =>
                @$log.info("Successfully listed #{@ctrlName} - status #{status}")
                deferred.resolve(data)
            )
        .error((data, status, headers) =>
                @$log.error("Failed to list #{@ctrlName} - status #{status}")
                deferred.reject(data);
            )
        deferred.promise

    save: (item) ->
        @$log.debug "save #{@ctrlName} #{angular.toJson(item)}"
        @filterNullProps(item)
        deferred = @$q.defer()

        @$http.post("/#{@ctrlName}/save", item)
        .success((data, status, headers) =>
                @$log.info("Successfully created #{@ctrlName} - status #{status}")
                deferred.resolve(data)
            )
        .error((data, status, headers) =>
                @$log.error("Failed to create #{@ctrlName} - status #{status}")
                deferred.reject(data);
            )
        deferred.promise
        
    delete: (item) ->
        @$log.debug "delete #{angular.toJson(item)}"
        deferred = @$q.defer()

        @$http.post("/#{@ctrlName}/delete", item)
        .success((data, status, headers) =>
                @$log.info("Successfully deleted #{@ctrlName} - status #{status}")
                deferred.resolve(data)
            )
        .error((data, status, headers) =>
                @$log.error("Failed to delete #{@ctrlName} - status #{status}")
                deferred.reject(data);
            )
        deferred.promise

servicesModule.service('ItemService', ItemService)